class Collection < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: [:slugged, :finders]

  has_and_belongs_to_many :packages, uniq: true
  has_many :filters
  has_many :categories

  default_scope { order "position asc" }

  def self.discover(pkg)
    collections = []
    collections << Collection.find("react-vr")     if self.assign_react_vr? pkg
    collections << Collection.find("react-native") if self.assign_react_native? pkg
    collections << Collection.find("react")        if self.assign_react? pkg
    collections << Collection.find("webpack")      if self.assign_webpack? pkg
    collections << Collection.find("browserify")   if self.assign_browserify? pkg
    collections << Collection.find("babel")        if self.assign_babel? pkg
    collections << Collection.find("postcss")      if self.assign_postcss? pkg
    collections << Collection.find("reactive")     if self.assign_reactive? pkg
    collections
  end

  def to_s
    name
  end

  private

  def self.assign_react_vr?(pkg)
    manifest = pkg.manifest || {}
    deps = manifest.fetch("dependencies", {}).keys
    deps << manifest.fetch("devDependencies", {}).keys
    deps << manifest.fetch("peerDependencies", {}).keys

    return true if deps.include? "react-vr"
    return true if [ pkg.name, pkg.description ].any? { |prop| prop.downcase =~ /react\-?vr\-/i }
    return true if pkg.keywords.any? { |k| k =~ /^(react[\-\s]?vr)/ }
    return false
  end

  def self.assign_react_native?(pkg)
    return true if [ pkg.name, pkg.description ].any? { |prop| prop.downcase =~ /react\-?native/i }
    return true if pkg.keywords.any? { |k| k =~ /^(react[\-\s]?native)/ }
    return false
  end

  def self.assign_react?(pkg)
    return false if assign_react_native? pkg
    return false if assign_react_vr? pkg
    return true if pkg.keywords.any? { |k| k =~ /^(react[\-\s]?component)/ }
    return true if pkg.name.downcase.include? "react-"
    return true if pkg.name.downcase.ends_with? "-react"
    return true if pkg.name.downcase.include? "electrode-"
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

  def self.assign_reactive?(pkg)
    return true if pkg.name =~ /^(rx[\-\.])/i
    return true if pkg.name.downcase.ends_with? "-rx"
    return true if pkg.keywords.any? { |k| k =~ /^(rx([\-\.]js)?)/ }

    return true if pkg.name =~ /^(cycle[\-\.])/i
    return true if pkg.name =~ /^(cyclejs[\-\.])/i
    return true if pkg.keywords.any? { |k| k =~ /^(cycle[\-\.]?js)/ }

    return true if pkg.name =~ /^(bacon[\-\.])/i
    return true if pkg.keywords.any? { |k| k =~ /^(bacon([\-\.]js)?)/ }

    return true if pkg.name =~ /^(kefir[\-\.])/i
    return true if pkg.keywords.any? { |k| k =~ /^(kefir([\-\.]js)?)/ }

    return false
  end
end
