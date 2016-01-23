# Add the ability to define secondary navigations to ActiveAdmin, like this:
#
#   class ExampleMenu
#     include JsCoach::SecondaryMenu
#
#     def menu_items
#       register "Submenu 1", url: url_helpers.example_path
#       register "Submenu 2", url: "http://david.tools"
#     end
#   end
#
#   ActiveAdmin.register_page "Example page" do
#     config.secondary_menu = ExampleMenu
#   end
#

# Add a new config for the secondary menu to both pages and resources
module ActiveAdmin
  class Page
    attr_accessor :secondary_menu
  end

  class Resource
    attr_accessor :secondary_menu
  end
end

module JsCoach

  # Set of methods which implement the logic behing the secondary menu. All menus
  # should include this module and reimplement the `menu_items` method.
  #
  module SecondaryMenu
    delegate :url_helpers, to: 'Rails.application.routes'

    # Method to be reimplement by menus
    def menu_items
      []
    end

    # Prevents menu items from being registered more than once
    def clear_menu_items!
      @menu_items = []
    end

    # Utility method to be used inside the `menu_items` method to register each item
    def register(label, url: "#")
      @menu_items ||= []
      @menu_items << { label: label, url: url }
    end
  end

  # Module to be included in ActiveAdmin pages and resources. Implements the logic
  # necessary to render the secondary navigation. It accesses the menu stored in the
  # page's (or resource) configuration using the `active_admin_config` method.
  #
  module SecondaryNavigationExtension
    def build_menu_items
      menu = active_admin_config.secondary_menu.new
      menu.clear_menu_items!
      menu.menu_items
    end

    def main_content
      build_secondary_menu if active_admin_config.secondary_menu
      super
    end

    def build_secondary_menu
      div class: "table_tools" do
        ul class: "scopes table_tools_segmented_control" do
          build_menu_items.each do |item|
            build_menu_item item
          end
        end
      end
    end

    def build_menu_item(item)
      li class: classes_for_menu_item(item) do
        a href: item[:url], class: "table_tools_button" do
          text_node item[:label]
        end
      end
    end

    def classes_for_menu_item(item)
      classes = %w{ scope menu-item }
      classes << "selected" if current_menu_item? item
      classes.join " "
    end

    def current_menu_item?(item)
      item[:url] == request.path
    end
  end

  # Add the new functionality to ActiveAdmin pages
  class Page < ActiveAdmin::Views::Pages::Page
    include SecondaryNavigationExtension
  end

  # Add the new functionality to ActiveAdmin resources
  class Index < ActiveAdmin::Views::Pages::Index
    include SecondaryNavigationExtension
  end
end
