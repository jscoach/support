class CollectionsMenu
  include JsCoach::SecondaryMenu

  def menu_items
    register "Accepted", url: url_helpers.state_sudo_collections_path(state: "accepted")
    register "Published", url: url_helpers.state_sudo_collections_path(state: "published")
    register "Both", url: url_helpers.sudo_collections_path
  end
end

ActiveAdmin.register Package, as: "Collections" do
  menu priority: 2

  actions :index

  decorate_with PackageDecorator

  config.sort_order = 'modified_at_desc'
  config.clear_sidebar_sections!

  config.enable_search = true
  config.secondary_menu = CollectionsMenu

  scope :all, default: true

  controller do
    before_filter only: :index do
      # If we haven't already, add one scope per collection.
      add_dynamic_scopes if active_admin_config.scopes.length == 1
    end

    # This is done in a `before_filter` because AA doesn't support dynamic scopes
    # (http://git.io/vRuzd) and doing this directly in the controller block will
    # prevent parts of the app from running without a DB (eg: asset precompilation).
    def add_dynamic_scopes
      Collection.all.each do |collection|
        scope = ActiveAdmin::Scope.new collection.name do |scoped|
          scoped.where("collections_packages.collection_id": collection)
        end
        active_admin_config.scopes << scope
      end
    end

    def scoped_collection
      states = params[:state] || [:accepted, :published]
      chain = end_of_association_chain.with_states(states)
      chain = chain.with_collections

      if active_admin_config.search_enabled? and params[:search].present?
        chain.search(params[:search])
      else
        chain
      end
    end
  end

  index title: proc { params[:state] ? "#{ params[:state].titleize }" : "Collections" } do
    selectable_column

    column :name do |resource|
      link_to resource.name, sudo_package_path(resource)
    end

    column :repository do |resource|
      link_to resource.repo.to_s, resource.github_url if resource.repo.present?
    end

    column :description
    column "Release", :latest_release
    column :stars
    column "Downloads", :last_month_downloads

    column :collections do |resource|
      resource.collections.join(", ")
    end

    column :tweeted
    column :last_fetched
    column :updated_at
    column :modified_at
  end

  batch_action :publish, if: proc { params[:state] == 'accepted' } do |ids|
    batch_action_collection.find(ids).each do |package|
      package.publish!
    end
    redirect_to collection_path, alert: "The packages have been published."
  end

  batch_action :unpublish, if: proc { params[:state] == 'published' } do |ids|
    batch_action_collection.find(ids).each do |package|
      package.accept!
    end
    redirect_to collection_path, alert: "The packages transitioned to accepted."
  end

  batch_action :reject do |ids|
    batch_action_collection.find(ids).each do |package|
      package.reject!
    end
    redirect_to collection_path, alert: "The packages transitioned to rejected."
  end
end
