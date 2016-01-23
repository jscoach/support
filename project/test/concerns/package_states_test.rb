require "test_helper"

class PackageStates < ActiveSupport::TestCase
  let(:npm_full) { JSON.parse File.read("test/support/react_package_full.json") }
  let(:github) { OpenStruct.new(fork: false, fetch_is_copy: false, stargazers_count: 42, full_name: "facebook/react") }

  it "has a default state" do
    Package.new.pending?.must_equal true
  end

  it "can be rejected" do
    pkg = Package.new(name: "example")
    pkg.reject!
    pkg.rejected?.must_equal true
  end

  it "requires `modified_at` values that sound reasonable" do
    pkg = packages :pending

    pkg.modified_at = nil
    pkg.valid?.must_equal true

    pkg.modified_at = Time.new(2000)
    pkg.valid?.must_equal false

    pkg.modified_at = Time.new(2012)
    pkg.valid?.must_equal true
  end

  it "requires a valid `repo` value" do
    pkg = packages :pending

    pkg.repo = "repouser/reponame"
    pkg.valid?.must_equal true

    pkg.repo = "something-else"
    pkg.valid?.must_equal false
  end

  describe "auto_transition" do
    it "changes rejected packages to pending if new data is given" do
      pkg = Package.new(name: "example")

      pkg.description = "Old description."
      pkg.reject!
      pkg.rejected?.must_equal true

      pkg.description = "New description."
      pkg.auto_transition.save
      pkg.description.must_equal "New description."
      pkg.pending?.must_equal true
    end
  end

  describe "auto_review" do
    it "reviews the package and transitions it to `rejected` or `accepted`" do
      npm = NPM::Package.new(npm_full)
      pkg = Package.new

      pkg.assign_npm_attributes(npm)
      pkg.pending?.must_equal true

      # If it's a fork, must be rejected
      github.fork = true
      pkg.assign_github_attributes(github)
      pkg.auto_review.save
      pkg.rejected?.must_equal true
      github.fork = false

      # If it's a copy, must be rejected
      github.fetch_is_copy = true
      pkg.assign_github_attributes(github)
      pkg.auto_review.save
      pkg.rejected?.must_equal true
      github.fetch_is_copy = false

      # If it doesn't have a readme, must be rejected
      github.fetch_readme = ""
      pkg.assign_github_attributes(github)
      pkg.auto_review.save
      pkg.rejected?.must_equal true
      github.fetch_readme = "Hello" * 80

      # Otherwise, will be accepted
      pkg.languages = { "Java" => 42 }
      pkg.last_week_downloads = 24
      pkg.last_month_downloads = 48
      pkg.downloads = [{ day: "2012-10-22", downloads: 85 }]
      pkg.dependents = 42
      pkg.assign_github_attributes(github)
      pkg.auto_review.save
      pkg.accepted?.must_equal true
    end
  end
end
