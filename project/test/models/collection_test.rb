require "test_helper"

class CollectionTest < ActiveSupport::TestCase
  before do
    Rails.application.load_seed
  end

  it "has default collections" do
    Collection.count.must_be :>, 1
  end

  describe "discover" do
    it "assigns the right collections" do
      pkg = Package.new(name: "react-native", description: "desc", keywords: ['react-component'])
      Collection.discover(pkg).must_equal [ Collection.find("react-native") ]

      pkg = Package.new(name: "hello", description: "world", keywords: ['postcss-plugin'])
      Collection.discover(pkg).must_equal [ Collection.find("postcss") ]

      pkg = Package.new(name: "hello", description: "world", keywords: ['react-component'])
      pkg.assign_collections! # Package has an helper method for this
      pkg.collections.must_equal [ Collection.find("react") ]
    end

    it "assigns automatically after save" do
      pkg = packages(:accepted_1)
      pkg.collections = []
      pkg.keywords = ['react-component']
      pkg.save!
      pkg.accepted?.must_equal true

      pkg.collections.to_a.must_equal [ Collection.find("react") ]
    end
  end
end
