require "test_helper"

class PackageGithubRelated < ActiveSupport::TestCase
  let(:npm_full) { JSON.parse File.read("test/support/react_package_full.json") }
  let(:github) { OpenStruct.new(fork: false, stargazers_count: 42, full_name: "facebook/react") }

  describe "assign_github_attributes" do
    it "updates the repo if GitHub redirects to new repository" do
      npm_full["repository"]["url"] = "https://github.com/facebook/react-old"

      npm = NPM::Package.new(npm_full)
      pkg = Package.new
      pkg.assign_npm_attributes(npm)

      pkg.repo.must_equal "facebook/react-old"
      pkg.original_repo.must_equal "facebook/react-old"

      pkg.assign_github_attributes(github)

      pkg.repo.must_equal "facebook/react"
      pkg.original_repo.must_equal "facebook/react-old"
    end
  end
end
