class Category < ActiveRecord::Base
  module ReactNative
    extend ActiveSupport::Concern

    class_methods do
      def discover_react_native(collection, pkg)
        categories = []
        keywords = pkg.keywords.to_a

        keywords.map(&:downcase).each do |keyword|
          # Bypass the ones that are safe to ignore
          next if keyword.singularize =~ /^(react[\-\s]?native|react[\-\s]?component|react[\-\s]?native[\-\s]?component|component)$/
          next if keyword =~ /^(react|reactjs|native|mobile|ios|android|ui)$/

          categories << "images" if keyword.singularize =~ /image|svg/
          categories << "images" if keyword.singularize =~ /^icon$/
          categories << "routers" if keyword.singularize =~ /router/
          categories << "indicators" if keyword.singularize =~ /^(spinner|progress|progress[\-\s]?bar|loading)$/
          categories << "indicators" if keyword.singularize =~ /^(loader|activity[\-\s]?indicator|refresh|indicator)$/
          categories << "navigation" if keyword.singularize =~ /^(navigation|navbar|navigator|navigation[\-\s]?bar|location)$/
          categories << "contacts" if keyword.singularize =~ /^(contact|address[\-\s]?book)$/
          categories << "data-flow" if keyword.singularize =~ /(flux|redux|async[\-\s]?storage|sqlite|rest|database|download|upload)/
          categories << "data-flow" if keyword.singularize =~ /^(data|file|filesystem|sync|fetch|leveldb|local[\-\s]?storage)$/
          categories << "styling" if keyword.singularize =~ /(css|stylesheet|styling|material[\-\s]?design)/
          categories << "styling" if keyword.singularize =~ /^style$/
          # categories << "tests" if keyword.singularize =~ /^(ab|test|testing)$/
        end

        categories.uniq.map { |slug| collection.categories.find(slug) }
      end
    end
  end
end
