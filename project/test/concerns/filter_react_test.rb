require "test_helper"

class FilterReactTest < ActiveSupport::TestCase
  before do
    Rails.application.load_seed
  end

  describe "discover" do
    it "assigns the right filters for react" do
      pkg = Package.new(name: "foo", collections: [ Collection.find("react") ])
      inline_styles_filter = Filter.find_by(slug: "inline-styles", collection: Collection.find("react"))

      pkg.languages = { "JavaScript": 42, "CSS": 42 }
      Filter.discover(pkg).must_be_empty

      pkg.languages = { "JavaScript": 42 }
      Filter.discover(pkg).must_equal [ inline_styles_filter ]
    end
  end
end
