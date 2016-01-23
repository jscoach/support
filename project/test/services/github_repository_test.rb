require "test_helper"

class GithubRepository < ActiveSupport::TestCase
  let(:npm_short) { JSON.parse File.read("test/support/react_package_short.json") }

  describe "new" do
    it "finds a missing repo using NPM and GitHub" do
      user_profile_url = "https://www.npmjs.com/~zpao"
      user_profile_html = File.read("./test/support/npm_user_profile.html")
      FakeWeb.register_uri(:get, user_profile_url, body: user_profile_html, content_type: "text/html")

      npm_short["homepage"] = nil
      npm_short["repository"] = nil
      npm = NPM::Package.new(npm_short)
      npm.repo.must_be_nil

      Octokit.stub(:repo, OpenStruct.new(full_name: "foo/bar")) do
        github = Github::Repository.new(npm, fetch: true)
        github.full_name.must_equal "foo/bar"
      end
    end
  end

  describe "fetch_is_copy" do
    it "detects if the repository has a package.json with distinct name" do
      response = OpenStruct.new(content: Base64.encode64('{ "name": "real-react" }'))
      Octokit.stub(:contents, response) do
        npm = NPM::Package.new(name: "react")
        github = Github::Repository.new(npm)
        github.fetch_is_copy.must_equal true
        github.fetch_manifest["name"].must_equal "real-react"
      end
    end
  end
end
