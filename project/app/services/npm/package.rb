module NPM
  class Package
    attr_reader :dependents,
      :description,
      :downloads,
      :homepage,
      :keywords,
      :last_month_downloads,
      :last_week_downloads,
      :license,
      :name,
      :custom_repo

    # @param hash A package in JSON format from one of the NPM APIs
    # @param fetch If `true` fetches data from NPM registry
    def initialize(hash = {}, options = { fetch: false })
      npm = hash.with_indifferent_access

      if options[:fetch] and npm[:name].blank?
        raise JsCoach::ArgumentError.new "You must give a package name in order to fetch"
      end

      @custom_repo = hash[:custom_repo] # Allow to pass this manually as a default

      initialize_from_hash(npm)
      fetch if options[:fetch]
      freeze
    end

    def initialize_from_hash(hash)
      npm = hash.with_indifferent_access

      @author = npm[:author]
      @description = npm[:description]
      @dist_tags = npm["dist-tags"]
      @homepage = npm[:homepage]
      @keywords = npm[:keywords]
      @license = npm[:license]
      @maintainers = npm[:maintainers]
      @name = npm[:name]
      @repository = npm[:repository]
      @time = npm[:time]
      @versions = npm[:versions]
    end

    def fetch(name = @name)
      initialize_from_hash Utils.fetch_package_manifest(name)

      @last_week_downloads = Utils.fetch_last_week_downloads(name) || 0
      @last_month_downloads = Utils.fetch_last_month_downloads(name) || 0
      @downloads = Utils.fetch_downloads(name) || {}
      @dependents = Utils.fetch_dependents(name) || 0
    end

    private :initialize_from_hash
    private :fetch

    # @return A hash with maintainers and/or author, or nil if neither is available
    def contributors(maintainers: @maintainers, author: @author)
      { maintainers: maintainers, author: author }.compact.presence
    end

    def maintainer_usernames(maintainers = @maintainers)
      maintainers.to_a.map { |m| m.with_indifferent_access[:name] }
    end

    def maintainer_users(maintainer_usernames = self.maintainer_usernames)
      maintainer_usernames.map { |username| NPM::User.new(username) }
    end

    def latest_release(dist_tags = @dist_tags)
      dist_tags.try(:[], "latest")
    end

    def modified_at(time = @time)
      time.try(:[], "modified")
    end

    # The `created` timestamp is only available on the full json from the show API
    def published_at(time = @time)
      time.try(:[], "created")
    end

    # The `manifest` (a valid package.json file) is only available on the full json the show API
    def manifest(versions: @versions, latest_release: self.latest_release)
      manifest = versions.try(:[], latest_release)

      # In the short API, it may have a "latest" string value, so make sure it's a hash
      manifest.is_a?(Hash) ? manifest : nil
    end

    def repo(repo_url = self.repo_url, homepage = @homepage)
      repo_url_to_repo(repo_url) ||
      repo_url_to_repo(homepage) # Try to find repo using the homepage
    end

    def repo_url(repository = @repository)
      repository_to_repo_url(repository)
    end

    private

    # Receives a `repository` property from NPM and converts it to a single GitHub URL
    # @param Array or Hash
    # @return URL to a GitHub repository (http:, git: or other) or nil
    def repository_to_repo_url(repository)
      return if !repository.is_a?(Array) and !repository.is_a?(Hash)

      # NPM allows both a single hash (with a `url` and a optional `type`) or
      # an array of hashes. Uniform to always be an array
      repository = [repository] unless repository.is_a? Array

      # Reject all that don't have a URL property or that point to a non-github repository
      repository = repository.map(&:with_indifferent_access).find do |repo|
        repo[:url].present? and
        repo[:url].include?("github")
      end

      repository.try(:[], :url)
    end

    # Receives an URL to a repository and returns a GitHub shorthand
    # Eg: "http://github.com/madebyform/react-parts" becomes "madebyform/react-parts"
    # @return GitHub shorthand or nil
    def repo_url_to_repo(repo_url)
      return unless repo_url.is_a? String
      return if !repo_url.include?("github.com") or repo_url.include?("gist.github.com")

      repo = repo_url.gsub(/^.*\:\/*/i, '') # Remove protocol (eg: "http://", "github:")
        .gsub(/\.git(#.+)?$/i, '') # Remove .git (and optional branch) suffix
        .gsub(/.*github\.com[\/\:]+/i, '') # Remove domain or ssh clone url
        .gsub(/([^\/]+) \/ ([^\/]+) \/? .*/x, '\1/\2') # Remove everything after a possible second slash

      repo.split("/").size == 2 ? repo : nil # Check if the final value is well formatted
    end
  end
end
