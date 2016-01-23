require "test_helper"

class NPMUser < ActiveSupport::TestCase
  let(:username) { "npm_username" }
  let(:user_profile_url) { "#{ NPM::Utils::WEB_DOMAIN }/~#{ username }" }

  describe "new" do
    it "doesn't fetch data from the Internet by default" do
      user = NPM::User.new(username)
      user.github_username.must_be_nil
    end
  end

  describe "github_username" do
    it "gets the GitHub username of a NPM user by using her profile" do
      html = File.read("./test/support/npm_user_profile.html")
      FakeWeb.register_uri(:get, user_profile_url, body: html, content_type: "text/html")

      user = NPM::User.new(username, fetch: true)
      user.github_username.must_equal "github_username"
    end

    it "returns an empty string if unavailable" do
      html = '<html><body> <ul class="vanilla-list profile-sidebar-links"></ul> </body></html>'
      FakeWeb.register_uri(:get, user_profile_url, user_profile_url: html, content_type: "text/html")

      user = NPM::User.new(username, fetch: true)
      user.github_username.must_be_empty
    end
  end
end
