class Category < ActiveRecord::Base
  module React
    extend ActiveSupport::Concern

    KEYWORDS_TO_IGNORE = [
      "android",
      "component",
      "ios",
      "mobile",
      "react-component",
      "react-native-component",
      "react-native",
      "react",
      "reactjs",
      "react.js",
      "app",
      "application",
      "javascript",
      "isomorphic",
      "universal",
      "native",
      "tool",
      "framework",
      "facebook",
      "backbone",
      "functional"
    ]

    class_methods do
      def discover_react(collection, pkg)
        categories = []
        keywords = pkg.keywords.to_a

        keywords.map(&:downcase).each do |keyword|
          # Bypass the ones that are safe to ignore
          next if KEYWORDS_TO_IGNORE.map(&:singularize).include? keyword.gsub(" ", "-").singularize

          # Unique matching
          case keyword
          when /standard\-?style/
            categories += ["practices"]
          when /style\-?guide/
            categories += ["practices"]
          when /code\-?style/
            categories += ["practices"]
          when /style-?loader/
            categories += ["styling", "transforms", "setup"]
          when /style|inline|class/
            categories += ["styling"]
          end

          # Everything that matches should have additional category
          categories << "a11y" if keyword.singularize =~ /a11y|accessibility/
          categories << "animation" if keyword.singularize =~ /animate|animation/
          categories << "boilerplates" if keyword.singularize =~ /generat|scaffold|boilerplate|yeoman|gulp|grunt/
          categories << "boilerplates" if keyword.singularize == "cli"
          categories << "data-flow" if keyword.singularize =~ /flux|redux|store|state|event|immutable|unidirectional/
          categories << "data-viz" if keyword.singularize == "d3"
          categories << "data-viz" if keyword.singularize =~ /chart|graph/
          categories << "forms" if keyword.singularize =~ /^(form|date|time)$/
          categories << "forms" if keyword.singularize =~ /input|calendar|select|range|autocomplete|editable|textarea|slider|picker/
          categories << "i18n" if keyword.singularize =~ /i18n|internationalization/
          categories << "icons" if keyword.singularize =~ /icon|svg/
          categories << "images" if keyword.singularize =~ /image|img|photo|svg|gif/
          categories << "layout" if keyword.singularize =~ /grid|layout|flexbox/
          categories << "modals" if keyword.singularize =~ /modal|dialog/
          categories << "players" if keyword.singularize =~ /player|audio|video/
          categories << "practices" if keyword =~ /linter|eslint/
          categories << "rendering" if keyword =~ /jsx/
          categories << "rendering" if keyword.singularize =~ /render|express|template|view|dom/
          categories << "responsive" if keyword.singularize =~ /responsive/
          categories << "routers" if keyword.singularize =~ /route/
          categories << "setup" if keyword =~ /jsx/
          categories << "setup" if keyword.singularize == "middleware"
          categories << "setup" if keyword.singularize =~ /babel|browserify|webpack|gulp|grunt/
          categories << "styling" if keyword.singularize =~ /(material|css|twitter[\s\-]?bootstrap|react[\s\-]?bootstrap|flexbox)/
          categories << "testing" if keyword.singularize =~ /test|mocha/
          categories << "transforms" if keyword.singularize =~ /^(babel|browserify|webpack|loader)$/
          categories << "transforms" if keyword.singularize =~ /transform|babel/
        end

        categories.uniq.map { |slug| collection.categories.find(slug) }
      end
    end
  end
end
