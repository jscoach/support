module NPM
  class User
    attr_accessor :name, :github_username

    def initialize(name, options = { fetch: false })
      @name = name
      fetch if options[:fetch]
      freeze
    end

    private

    def fetch(name = @name)
      @github_username = Utils.fetch_github_username(name)
    end
  end
end
