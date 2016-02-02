module Github
  class Repository
    extend Memoist

    attr_accessor :full_name

    def initialize(npm_package, fetch: false)
      @npm_package = npm_package
      fetch_data if fetch
      freeze
    end

    def fetch_data(npm_package = @npm_package)
      @repo_data = fetch_repo_data
      @full_name = @repo_data.full_name
      # The remaining data must be fetched manually
    end

    private :fetch_data

    # The package may be a copy with the repository property pointing to the original
    # package. We can see if that's the case by comparing the package name with the
    # name property of the package.json in the associated repo
    # NOTE: An exception has been added for `remobile` because they always have both
    # scoped and global names, and they are a big deal in `react-native`
    def fetch_is_copy(npm_package: @npm_package, manifest: self.fetch_manifest)
      manifest.try(:[], 'name').present? and manifest['name'].sub("@remobile/", "") != npm_package.name
    end

    def fetch_repo_data(npm_package = @npm_package)
      if npm_package.custom_repo.present? or npm_package.repo.present?
        Utils.repo(npm_package.custom_repo.presence || npm_package.repo)
      else
        Utils.repo_using_npm_users(npm_package.maintainer_users, npm_package.name)
      end
    end

    def fetch_languages(full_name = @full_name)
      Utils.languages(full_name).to_h
    end
    memoize :fetch_languages

    # NPM can also be used to get a README, but sometimes authors don't include it in
    # the package, and they are usually more outdated.
    # We would also need to convert the Markdown to HTML, with the risk of obtaining
    # a different output than GitHub has. GitHub gives us rendered HTML with syntax
    # highlighting, so it's more convenient.
    def fetch_readme(full_name: @full_name, npm_package: @npm_package)
      readme = Utils.readme(full_name, accept: 'application/vnd.github.html')
      JS::ReadMe.execute(readme, {
        name: npm_package.name,
        description: npm_package.description,
        repo: full_name
      })
    rescue Utils::NotFound
      # The GitHub README was not found
    end
    memoize :fetch_readme

    # The package may be a copy with the repository property pointing to the original
    # package. We can see if that's the case by comparing the package name with the
    # name property of the package.json in the associated repo
    def fetch_manifest(full_name: @full_name)
      response = Utils.contents(full_name, path: 'package.json')
      content = Base64.decode64(response.content)
      JSON.parse(content)
    rescue Utils::NotFound
      # A package.json file was not found at the root of the repository. This may
      # be a monorepo (with a `packages` directory) so ignore the error
      JsCoach.log "\r#{ full_name } does not have a `package.json` file at the root"
    rescue JSON::ParserError
      # The file is an invalid JSON file
      JsCoach.log "\r#{ full_name } has an invalid package.json file on GitHub"
    end
    memoize :fetch_manifest

    private

    # Delegate all missing methods to `@repo_data` (eg: `stargazers_count`)
    def method_missing(sym, *args, &block)
      @repo_data.send sym, *args, &block
    end
  end
end
