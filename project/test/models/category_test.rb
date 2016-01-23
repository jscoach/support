require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  before do
    Rails.application.load_seed
  end

  it "has default categories" do
    Filter.count.must_be :>, 1
  end

  describe "discover" do
    it "assigns automatically after collection assignment" do
      FakeWeb.register_uri(:get, Category::PLUGINS_URL, body: "[]", content_type: "application/json")

      pkg = packages(:accepted_1)
      pkg.collections = []
      pkg.keywords = [ "postcss-plugin", "scoping" ]
      pkg.save!

      pkg.categories.to_a.must_equal [ Collection.find("postcss").categories.find("scoping") ]
    end
  end
end
