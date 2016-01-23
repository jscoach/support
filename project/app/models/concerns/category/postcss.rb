class Category < ActiveRecord::Base
  module Postcss
    extend ActiveSupport::Concern

    PLUGINS_URL = "https://raw.githubusercontent.com/himynameisdave/postcss-plugins/master/plugins.json"

    class_methods do
      def discover_postcss(collection, pkg)
        categories = []
        keywords = pkg.keywords.to_a

        # Get more keywords from `postcss-plugins`
        plugin = plugin(pkg.name)
        keywords |= plugin["tags"] if plugin.present?

        keywords.map(&:downcase).each do |keyword|
          # Bypass the ones that are safe to ignore
          next if keyword.singularize =~ /^(css|postcss|postcss[\s\-]?plugin|plugin|other)$/

          categories << "analysis" if keyword == "analysis"
          categories << "colors" if keyword.singularize == "color"
          categories << "debug" if keyword.singularize =~ /debug|reporter/
          categories << "extensions" if keyword.singularize =~ /extension|extend|sass|scss|less|mixin|comment|nested/
          categories << "fallbacks" if keyword.singularize == "fallback"
          categories << "fonts" if keyword.singularize =~ /font|typography/
          categories << "future-css" if keyword.singularize =~ /future/
          categories << "fun" if keyword == "fun"
          categories << "grids" if keyword.singularize =~ /grid|layout/
          categories << "images" if keyword.singularize =~ /image|svg/
          categories << "media-queries" if keyword =~ /^media|query|queries|mq|max-width/
          categories << "optimizations" if keyword.singularize =~ /optimi[zs]ation|optimi[zs]e|critical|normali[zs]e|minif/
          categories << "packs" if keyword.singularize == "pack"
          categories << "scoping" if keyword.singularize =~ /scope|scoping|specificity|module|component/
          categories << "shortcuts" if keyword.singularize == "shortcut"
        end

        categories.uniq.map { |slug| collection.categories.find(slug) }
      end

      # Get the metadata associated to a given plugin from the `postcss-plugins` project
      # @return A hash with the plugin metadata
      def plugin(plugin_name)
        plugins.detect { |plugin| plugin_name == plugin["name"] }
      end

      # Grab a list of plugins from the `postcss-plugins` project
      # @return An array of hashes with plugin metadata
      def plugins(agent: URLHelpers.default_agent)
        @_plugins ||= JSON.parse(agent.get(PLUGINS_URL).body)
      end
    end
  end
end
