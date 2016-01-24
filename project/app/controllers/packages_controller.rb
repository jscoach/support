class PackagesController < ApplicationController
  before_action :redirect_if_all

  def index
    respond_to do |format|
      format.html { render :index, locals: index_html }
      format.json { render json: index_json }
    end
  end

  def index_html
    index_json.merge({
      collections: [{
          name: "Everything",
          slug: "all"
        }, {
          name: "Pinned",
          slug: "pinned"
        }].concat(collections.as_json({
          only: [
            :name,
            :slug
          ]
        })
      ),
      packagesPerPage: Package.default_per_page,
      sheet: {
        welcome: view_context.render("welcome"),
        pinned: view_context.render("levelup")
      },
      notification: flash.to_hash.values.first
    })
  end

  def index_json
    {
      filters: collection_filters.as_json({
        only: [
          :name,
          :slug
        ]
      }),
      categories: (collection_categories.present? ? [{
          name: "All",
          slug: "all"
        }].concat(collection_categories.as_json({
          only: [
            :name,
            :slug
          ]
        }).concat([{
          name: "Other",
          slug: "other"
        }])
      ) : []),
      packages: decorated_packages.as_json({
        only: [
          :name,
          :repo,
          :description,
          :latest_release,
          :downloads_svg
        ],
        methods: [
          :repo_user,
          :relative_modified_at,
          :relative_published_at,
          :humanized_collections,
          :humanized_stars,
          :stars,
          :humanized_last_month_downloads,
          :last_month_downloads,
          :filters
        ]
      }),
      packagesCount: searched_packages.count,
      packagesSort: sort_by,
      packagesDefaultSort: default_sort_by
    }
  end

  def show
    respond_to do |format|
      format.html { render :index, locals: show_html }
      format.json { render json: show_json }
    end
  end

  def show_html
    index_html.merge(show_json)
  end

  def show_json
    decorated_package.as_json({
      only: [
        :name,
        :repo,
        :readme
      ],
      methods: [
        :repo_user,
        :relative_modified_at,
        :relative_published_at,
        :humanized_collections
      ]
    })
  end

  private

  # To make the URL cleaner, redirect /all to /
  def redirect_if_all
    if request.path == "/all" and request.format != "json"
      redirect_to root_path
    end
  end

  def default_sort_by
    params[:search].present? ? "popular" : "updated"
  end

  def sort_by
    if ["popular", "updated", "new"].include? params[:sort]
      params[:sort]
    else
      default_sort_by
    end
  end

  def show_all_collections?
    params[:collection_id].blank? or params[:collection_id] == "all"
  end

  def show_pinned_collection?
    params[:collection_id] == "pinned"
  end

  def collections
    @_collections ||= Collection.where(default: true)
  end

  def collection
    @_collection ||= Collection.find(params[:collection_id])
  end

  def collection_filters
    @_collection_filters ||= if show_all_collections? or show_pinned_collection?
      Filter.none
    else
      Filter.where(collection: collection)
    end
  end

  def collection_categories
    @_collection_categories ||= if show_all_collections? or show_pinned_collection?
      Category.none
    else
      Category.where(collection: collection)
    end
  end

  def packages
    @_packages ||= if show_all_collections?
      Package.with_collections
    elsif show_pinned_collection?
      Package.none
    else
      collection.packages
    end
  end

  def category_packages
    @_category_packages ||= if params[:category].blank? or params[:category] == "all"
      packages
    elsif params[:category] == "other"
      packages.without_categories(collection_categories)
    else
      collection.categories.find(params[:category]).packages
    end
  end

  def published_packages
    category_packages
      .with_state(:published)
      .includes(:collections)
      .includes(:filters)
  end

  def searched_packages
    @_searched_packages ||= if params[:search].present?
      published_packages.search(params[:search])
    else
      published_packages
    end
  end

  def sorted_packages
    @_sorted_packages ||= begin
      case sort_by
      when "popular"
        searched_packages.reorder("stars desc, last_month_downloads desc")
      when "updated"
        searched_packages.reorder("modified_at desc")
      when "new"
        searched_packages.reorder("published_at desc")
      end
    end
  end

  # If nil, 0 or 1 is passed to `page`, the same first page of results is returned
  def paginated_packages
    @_paginated_packages ||= sorted_packages.page(params[:page])
  end

  # FIXME `to_a.uniq` is used to force uniqueness for search results in the "Everything"
  # tab for packages that belong to more than one collection. This is not an ideal fix
  # since it may show less than 25 results per page for search results.
  def decorated_packages
    @_decorated_packages ||= paginated_packages.to_a.uniq.map(&:decorate)
  end

  def package
    @_package ||= packages.find(params[:id])
  end

  def decorated_package
    @_decorated_package ||= package.decorate
  end
end
