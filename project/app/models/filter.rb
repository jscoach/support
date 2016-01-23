class Filter < ActiveRecord::Base
  include ReactNative
  include React

  extend FriendlyId

  friendly_id :name, use: [:scoped, :slugged, :finders], scope: :collection

  has_and_belongs_to_many :packages, uniq: true
  belongs_to :collection

  default_scope { order "position asc" }

  def self.discover(pkg)
    filters = []
    pkg.collections.each do |collection|
      case collection.slug
      when "react-native"
        filters |= discover_react_native(collection, pkg)
      when "react"
        filters |= discover_react(collection, pkg)
      end
    end
    filters
  end

  def to_s
    name
  end
end
