# Add the ability to define a search field to ActiveAdmin, like this:
#
#   ActiveAdmin.register Example do
#     config.enable_search = true
#   end
#

# Add new configs for the search field to both pages and resources
module ActiveAdmin
  module SearchConfig
    attr_accessor :enable_search

    def search_enabled?
      enable_search
    end
  end

  class Page
    include SearchConfig
  end

  class Resource
    include SearchConfig
  end
end

module JsCoach

  # Add a search field to the right of the title bar
  #
  module SearchExtension
    def build_titlebar_right
      div id: "titlebar_right" do
        if search_enabled?
          form id: "search", method: "get", 'accept-charset': "utf-8" do
            input type: "search", name: "search", value: params[:search], tabindex: "1",
              autocomplete: "off", autocapitalize: false, spellcheck: false

            # Keep existing query params
            request.query_parameters.except(:search).each do |k,v|
              input type: "hidden", name: k, value: v
            end
          end
        end

        build_action_items
      end
    end

    def search_enabled?
      active_admin_config.enable_search and params[:action] == "index"
    end
  end

  # Add the new functionality to ActiveAdmin title bars
  class TitleBar < ActiveAdmin::Views::TitleBar
    include SearchExtension
  end
end
