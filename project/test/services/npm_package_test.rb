require "test_helper"

class NPMPackage < ActiveSupport::TestCase
  describe "new" do
    it "parses a hash and returns a new record" do
      npm = NPM::Package.new({ "name" => "react", "description" => "Hello" })
      npm.name.must_equal "react"
      npm.description.must_equal "Hello"
    end
  end

  describe "repo_url" do
    let(:url) { "https://github.com/facebook/react.git" }
    let(:url_2) { "git@git.gree-dev.net:TestEngineer/abb.git" }

    it "converts a `repository` property from NPM to a single GitHub URL" do
      repository_prop = { type: "git", url: url }
      NPM::Package.new.repo_url(repository_prop).must_equal url

      repository_prop = [{ type: "git", url: url }]
      NPM::Package.new.repo_url(repository_prop).must_equal url

      repository_prop = [{ type: "git", url: url }, { url: url_2 }, { url: "" }]
      NPM::Package.new.repo_url(repository_prop).must_equal url
    end

    it "returns nil if no valid GitHub URL is found" do
      NPM::Package.new.repo_url([{ url: url_2 }, { url: "" }]).must_be_nil
      NPM::Package.new.repo_url({ url: "" }).must_be_nil
      NPM::Package.new.repo_url([]).must_be_nil
      NPM::Package.new.repo_url({}).must_be_nil
    end

    it "returns nil if input is invalid" do
      NPM::Package.new.repo_url(nil).must_be_nil
      NPM::Package.new.repo_url("").must_be_nil
    end
  end

  describe "repo" do
    it "converts an URL to a GitHub shorthand" do
      NPM::Package.new.repo("git+https://github.com/facebook/react.git").must_equal "facebook/react"
      NPM::Package.new.repo("git://github.com/andy128k/aes-es.git").must_equal "andy128k/aes-es"
      NPM::Package.new.repo("http://github.com/chrisdew/nodejs-mysql-native").must_equal "chrisdew/nodejs-mysql-native"
      NPM::Package.new.repo("git@github.com:gilt/ubar.git").must_equal "gilt/ubar"
      NPM::Package.new.repo("https///github.com//kiaking/actress/blob/master/LICENSE").must_equal "kiaking/actress"
    end

    it "returns nil if no valid GitHub URL is found" do
      NPM::Package.new.repo("git@git.gree-dev.net:TestEngineer/abb.git").must_be_nil
      NPM::Package.new.repo("git+https://gist.github.com/97d2c67ef35876a2eaaa.git").must_be_nil
      NPM::Package.new.repo("").must_be_nil
    end

    it "returns nil if input is invalid" do
      NPM::Package.new.repo(nil).must_be_nil
    end

    it "finds a missing repo using the homepage" do
      npm = NPM::Package.new(homepage: "https://github.com/some/repo")
      npm.repo.must_equal "some/repo"
    end
  end

  describe "maintainer_usernames" do
    it "converts the `maintainers` property to an array of NPM usernames" do
      maintainers = [{ name: "zolmeister", email: "zolikahan@gmail.com" }]
      pkg = NPM::Package.new(maintainers: maintainers)
      pkg.maintainer_usernames.must_equal ["zolmeister"]

      maintainers = [{ name: "user0", email: "email" }, { name: "user1", email: "email" }]
      pkg = NPM::Package.new(maintainers: maintainers)
      pkg.maintainer_usernames.must_equal ["user0", "user1"]

      maintainers = []
      pkg = NPM::Package.new(maintainers: maintainers)
      pkg.maintainer_usernames.must_equal []
    end
  end
end
