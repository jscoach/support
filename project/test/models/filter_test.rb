require "test_helper"

class FilterTest < ActiveSupport::TestCase
  before do
    Rails.application.load_seed
  end

  it "has default filters" do
    Filter.count.must_be :>, 1
  end

  describe "discover" do
    it "assigns automatically after collection assignment" do
      pkg = packages(:accepted_1)
      pkg.collections = []
      pkg.keywords = [ "react-native", "react-component" ]
      pkg.languages = { "Java": 42 }

      pkg.save!
      pkg.accepted?.must_equal true

      android_filter = Filter.find_by(slug: "android", collection: Collection.find("react-native"))
      pkg.filters.to_a.must_equal [ android_filter ]
    end
  end
end
