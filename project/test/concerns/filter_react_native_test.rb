require "test_helper"

class FilterReactNativeTest < ActiveSupport::TestCase
  before do
    Rails.application.load_seed
  end

  describe "discover" do
    it "assigns the right filters for react-native" do
      pkg = Package.new(name: "foo", collections: [ Collection.find("react-native") ])

      android_filter = Filter.find_by(slug: "android", collection: Collection.find("react-native"))
      ios_filter = Filter.find_by(slug: "ios", collection: Collection.find("react-native"))

      # Using languages
      pkg.keywords = []
      pkg.languages = { "Java": 42 }
      Filter.discover(pkg).must_equal [ android_filter ]

      # Only if there are languages we use the keywords. This is because React.parts used
      # to recommend adding the `ios` keyword before react-native for android was released.
      # This approach gives more accurate results. More info: http://git.io/vErCb
      pkg.keywords = [ "Android" ]
      pkg.languages = {}
      Filter.discover(pkg).must_be_empty

      # Using keywords
      pkg.keywords = [ "something-android" ]
      pkg.languages = { "Swift": 42 }
      Filter.discover(pkg).must_equal [ android_filter, ios_filter ]

      pkg.keywords = [ "android", "ios" ]
      pkg.languages = { "Swift": 42 }
      Filter.discover(pkg).must_equal [ android_filter, ios_filter ]
    end
  end
end
