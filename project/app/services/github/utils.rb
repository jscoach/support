module Github
  module Utils
    include Octokit

    # Returns repository information using a list of NPM users
    # @return Resource object or raises if the repository was not found
    def self.repo_using_npm_users(users, repo_name)
      users.each do |user|
        repo_data = repo_using_npm_user(user, repo_name)
        return repo_data unless repo_data.nil?
      end

      raise RepoNotFound.new "Repository was not found for '#{ repo_name }'."
    end

    private

    # @return Resource object or nil if the repository was not found
    def self.repo_using_npm_user(user, repo_name)
      # Try to get GitHub username from NPM user profile
      # If it can't be found assume it's the same as the NPM username
      username = user.github_username.presence || user.name
      user_or_org_repo(username, repo_name)
    end

    # Similar to the `repo` method but searches on the user's organizations too
    # @return Resource object or nil if the repository was not found
    def self.user_or_org_repo(username, reponame)
      begin
        return repo("#{ username }/#{ reponame }")
      rescue NotFound
        # The GitHub user or repository was not found
      end

      begin
        orgnames = orgs(username).map(&:login)
      rescue NotFound
        return # The GitHub user was not found
      end

      orgnames.each do |orgname|
        begin
          return repo("#{ orgname }/#{ reponame }")
        rescue NotFound
          # The GitHub repo was not found
        end
      end

      return
    end

    # Delegate all missing methods to Octokit
    def self.method_missing(sym, *args, &block)
      Octokit.send sym, *args, &block
    end
  end
end
