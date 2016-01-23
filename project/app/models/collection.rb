class Collection < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: [:slugged, :finders]

  has_and_belongs_to_many :packages, uniq: true
  has_many :filters
  has_many :categories

  default_scope { order "position asc" }

  def self.discover(pkg)
    collections = []
    collections << Collection.find("react-native") if self.assign_react_native? pkg
    collections << Collection.find("react")        if self.assign_react? pkg
    collections << Collection.find("webpack")      if self.assign_webpack? pkg
    collections << Collection.find("browserify")   if self.assign_browserify? pkg
    collections << Collection.find("babel")        if self.assign_babel? pkg
    collections << Collection.find("postcss")      if self.assign_postcss? pkg
    collections
  end

  def to_s
    name
  end

  private

  def self.assign_react_native?(pkg)
    return true if [ pkg.name, pkg.description ].any? { |prop| prop.downcase =~ /react\-?native/i }
    return true if pkg.keywords.any? { |k| k =~ /^(react[\-\s]?native)/ }
    return false
  end

  def self.assign_react?(pkg)
    return false if assign_react_native? pkg
    return true if pkg.keywords.any? { |k| k =~ /^(react[\-\s]?component)/ }
    return true if pkg.name.downcase.include? "react-"
    return true if pkg.name.downcase.ends_with? "-react"
    return false
  end

  def self.assign_webpack?(pkg)
    return true if pkg.keywords.any? { |k| k =~ /^(webpack[\-\s]?plugin)/ }
    return true if pkg.description.downcase.include? "webpack plugin"
    return true if pkg.name.downcase.include? "webpack"
    return false
  end

  def self.assign_browserify?(pkg)
    return true if pkg.keywords.any? { |k| k =~ /^(browserify[\-\s]?plugin)/ }
    return true if pkg.description.downcase.include? "browserify plugin"
    return true if pkg.name.downcase.include? "browserify"
    return false
  end

  def self.assign_babel?(pkg)
    return true if pkg.keywords.any? { |k| k =~ /^(babel[\-\s]?plugin)/ }
    return true if pkg.description.downcase.include? "babel plugin"
    return true if pkg.keywords.any? { |k| k =~ /^(babel[\-\s]?helper)/ }
    return true if pkg.description.downcase.include? "babel helper"
    return true if pkg.name.downcase.include? "babel"
    return false
  end

  def self.assign_postcss?(pkg)
    return true if pkg.keywords.any? { |k| k =~ /^(postcss[\-\s]?plugin)/ }
    return true if pkg.description.downcase.include? "postcss plugin"
    return true if pkg.name.downcase.include? "postcss"
    return false
  end
end
