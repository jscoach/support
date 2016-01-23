class Filter < ActiveRecord::Base
  module React
    extend ActiveSupport::Concern

    class_methods do
      def discover_react(collection, pkg)
        filters = []
        filters << collection.filters.find("inline-styles") if assign_inline_styles_filter? pkg
        filters
      end

      def assign_inline_styles_filter?(pkg)
        return false if pkg.languages.has_key? "CSS"
        return true
      end
    end
  end
end
