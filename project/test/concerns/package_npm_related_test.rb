require "test_helper"

class PackageNPMRelated < ActiveSupport::TestCase
  let(:npm_short) { JSON.parse File.read("test/support/react_package_short.json") }
  let(:npm_full) { JSON.parse File.read("test/support/react_package_full.json") }

  describe "assign_npm_attributes" do
    it "assigns the short data from NPM" do
      npm = NPM::Package.new(npm_short)
      pkg = Package.new
      pkg.assign_npm_attributes(npm)

      pkg.name.must_equal "react"
      pkg.repo.must_equal "facebook/react"
      pkg.description.must_equal "React is a JavaScript library for building user interfaces."
      pkg.original_description.must_equal pkg.description

      pkg.latest_release.must_equal "0.14.3"
      pkg.modified_at.hour.must_equal 2
      pkg.keywords.must_equal ["react"]
      pkg.homepage.must_equal "https://github.com/facebook/react/tree/master/npm-react"
      pkg.license.must_equal "BSD-3-Clause"

      contributors = {
        maintainers: [
          { name: "zpao", email: "paul@oshannessy.com" },
          { name: "jeffmo", email: "jeff@anafx.com" }
        ]
      }
      pkg.contributors.to_json.must_equal contributors.to_json

      pkg.valid?.must_equal true
    end

    it "parses the full data from NPM successfully" do
      npm = NPM::Package.new(npm_full)
      pkg = Package.new
      pkg.assign_npm_attributes(npm)

      pkg.published_at.hour.must_equal 17
      pkg.manifest["version"].must_equal npm_full["versions"]["0.14.3"]["version"]
    end
  end
end
