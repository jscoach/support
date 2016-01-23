class Package < ActiveRecord::Base
  module Search
    extend ActiveSupport::Concern

    include PgSearch

    included do
      pg_search_scope :pg_search,
        against: [
          :name,
          :original_description,
          :original_repo,
          :keywords,
        ],
        using: {
          tsearch: {
            prefix: true, # Search for partial words
            negation: true, # Any term that begins with an ! will be excluded
            any_word: false, # Return all records containing any word in the search term
            dictionary: "english" # Enables stemming
          }
          # trigram: {} # For typos and misspellings
        }
    end

    class_methods do
      def search(query)
        pg_search query.gsub("-", " ")
      end
    end
  end
end
