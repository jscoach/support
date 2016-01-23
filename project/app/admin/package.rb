ActiveAdmin.register Package do
  menu priority: 1

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :repo, :description, :whitelisted, collection_ids: []

  actions :index, :show, :edit, :update

  decorate_with PackageDecorator

  scope :pending
  scope :rejected
  scope :accepted, default: true

  config.sort_order = 'created_at_desc'

  config.enable_search = true

  controller do
    def scoped_collection
      if active_admin_config.search_enabled? and params[:search].present?
        end_of_association_chain.search(params[:search])
      else
        end_of_association_chain
      end
    end
  end

  filter :stars
  filter :hidden

  index do
    selectable_column

    column :name do |resource|
      link_to resource.name, sudo_package_path(resource)
    end

    column :repository do |resource|
      link_to resource.repo.to_s, resource.github_url if resource.repo.present?
    end

    column :custom do |resource|
      status_tag resource.repo!.present?
    end

    column :description

    column :custom do |resource|
      status_tag resource.description!.present?
    end

    column :readme do |resource|
      num_chars = resource.readme_plain_text.size
      status_tag(num_chars, num_chars >= Package::README_MIN_LENGTH ? :green : :red)
    end

    column :fork do |resource|
      status_tag resource.is_fork
    end

    column :stars

    column "Release", :latest_release
    column :modified_at
    column :last_fetched
    column :updated_at
    column :created_at
  end

  show do
    columns do
      column span: 2 do
        panel "README", class: "readme" do
          package.readme.to_s.html_safe
        end
      end

      column do
        panel 'Package metadata' do
          attributes_table_for package do
            row :state do |resource|
              status_tag resource.state.titleize, :ok
            end

            row :collections do |resource|
              resource.collections.join(", ")
            end

            row :repository do |resource|
              link_to resource.repo.to_s, resource.github_url if resource.repo.present?
            end
            row :custom_repository do |resource|
              status_tag resource.repo!.present?
            end

            row :description
            row :custom_description do |resource|
              status_tag resource.description!.present?
            end

            row :readme do |resource|
              num_chars = resource.readme_plain_text.size
              status_tag(num_chars, num_chars >= Package::README_MIN_LENGTH ? :green : :red)
            end

            row :latest_release
            row :modified_at
            row :stars

            row "Downloads" do |resource|
              if resource.last_week_downloads and resource.last_month_downloads
                "#{ resource.last_week_downloads } last week, " +
                "#{ resource.last_month_downloads } last month"
              end
            end
          end
        end

        panel 'Other metadata' do
          attributes_table_for package do
            row :keywords do |resource|
              resource.keywords.join(", ")
            end

            row :languages do |resource|
              languages = resource.languages.to_h
              languages.map { |name, bits| "#{ name } (#{ bits })" }.join("<br>").html_safe
            end

            row :is_fork do |resource|
              status_tag resource.is_fork, :ok
            end

            row :published_at
            row :license
            row :homepage
            row :created_at
            row :updated_at

            row :contributors do |resource|
              pre { JSON.pretty_generate resource.contributors } if resource.contributors.present?
            end

            row :manifest do |resource|
              pre { JSON.pretty_generate resource.manifest } if resource.manifest.present?
            end
          end
        end
      end
    end
  end

  form do |f|
    columns do
      column do
        f.inputs "Update #{ package.name }" do
          f.input :repo
          f.input :description, input_html: { rows: 6 }
          f.input :whitelisted, label: "Whitelisted (relaxes validations)"
          f.input :collections, collection: Collection.all, as: :check_boxes
        end

        f.actions
      end

      column do
      end
    end
  end

  batch_action :pending, if: proc { @current_scope.scope_method == :rejected } do |ids|
    batch_action_collection.find(ids).each do |package|
      package.pending!
    end
    redirect_to collection_path, alert: "The packages transitioned to pending."
  end

  batch_action :reject, if: proc { @current_scope.scope_method != :rejected } do |ids|
    batch_action_collection.find(ids).each do |package|
      package.reject!
    end
    redirect_to collection_path, alert: "The packages transitioned to rejected."
  end

  batch_action :toggle_visibility do |ids|
    batch_action_collection.find(ids).each do |package|
      package.hidden = !package.hidden
      package.save!
    end
    redirect_to collection_path, alert: "The packages visibility was updated."
  end

  member_action :toggle_visibility, method: :put do
    resource.hidden = !resource.hidden
    resource.save!
    redirect_to resource_path, notice: "The package visibility was updated."
  end

  member_action :pending, method: :put do
    resource.pending!
    redirect_to resource_path, notice: "The package transitioned to pending."
  end

  member_action :reject, method: :put do
    resource.reject!
    redirect_to resource_path, notice: "The package transitioned to rejected."
  end

  member_action :unpublish, method: :put do
    resource.accept!
    redirect_to resource_path, notice: "The package transitioned to accepted."
  end

  member_action :publish, method: :put do
    resource.publish!
    redirect_to resource_path, notice: "The package transitioned to published."
  end

  action_item :toggle_visibility, only: :show do
    label = package.hidden? ? "Show package" : "Hide package"
    link_to label, toggle_visibility_sudo_package_path(package), method: :put
  end

  action_item :reject, only: :show do
    unless package.rejected? or package.published?
      link_to "Reject", reject_sudo_package_path(package), method: :put
    end
  end

  action_item :other_states, only: :show do
    if package.rejected?
      link_to "Pending", pending_sudo_package_path(package), method: :put
    elsif package.accepted?
      link_to "Publish", publish_sudo_package_path(package), method: :put
    elsif package.published?
      link_to "Unpublish", unpublish_sudo_package_path(package), method: :put
    end
  end
end
