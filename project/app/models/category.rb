class Category < ActiveRecord::Base
  include Postcss
  include ReactNative
  include React

  extend FriendlyId

  friendly_id :name, use: [:scoped, :slugged, :finders], scope: :collection

  has_and_belongs_to_many :packages, uniq: true
  belongs_to :collection

  default_scope { order "position asc" }

  def self.discover(pkg)
    categories = []
    pkg.collections.each do |collection|
      case collection.slug
      when "postcss"
        categories |= discover_postcss(collection, pkg)
      when "react-native"
        categories |= discover_react_native(collection, pkg)
      when "react"
        categories |= discover_react(collection, pkg)
      end
    end
    categories
  end

  def to_s
    name
  end
end
