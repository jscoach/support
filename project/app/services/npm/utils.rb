module NPM
  module Utils
    extend self

    WEB_DOMAIN = "https://www.npmjs.com"
    REGISTRY_DOMAIN = "https://registry.npmjs.com"
    API_DOMAIN = "https://api.npmjs.org"
    LAUNCH_DATE = Date.new(2010, 12, 15)

    # Gets the full manifest of a package from NPM
    # Encode the "/" but not the "@" for compability with scoped packages (eg: "@storybook/react")
    def fetch_package_manifest(name, agent: URLHelpers.default_agent)
      JSON.parse agent.get("#{ REGISTRY_DOMAIN }/#{ name.gsub("/", "%2F") }").body
    end

    # @return integer representing number downloads from last week
    def fetch_last_week_downloads(name, agent: URLHelpers.default_agent)
      url = "#{ API_DOMAIN }/downloads/point/last-week/#{ name }"
      json = JSON.parse agent.get(url).body
      json["downloads"]
    end

    # @return integer representing number downloads from last month
    def fetch_last_month_downloads(name, agent: URLHelpers.default_agent)
      url = "#{ API_DOMAIN }/downloads/point/last-month/#{ name }"
      json = JSON.parse agent.get(url).body
      json["downloads"]
    end

    # @return json with data regarding downloads
    # Eg: [{ day: "2012-10-22", downloads: 85 }, ...]
    def fetch_downloads(name, agent: URLHelpers.default_agent)
      start_date = LAUNCH_DATE.to_s
      end_date = Date.current.to_s
      url = "#{ API_DOMAIN }/downloads/range/#{ start_date }:#{ end_date }/#{ name }"
      json = JSON.parse agent.get(url).body
      json["downloads"]
    end

    # @return GitHub username or an empty string
    def fetch_github_username(username, agent: URLHelpers.default_agent)
      profile_page = fetch_user_profile_page(username, agent: agent)
      profile_page.search(".github a").text().gsub("@", "")
    end

    # @return Return the number of packages that depend on the given package
    def fetch_dependents(name, limit: 50000, agent: URLHelpers.default_agent)
      url = "#{ REGISTRY_DOMAIN }/-/_view/dependedUpon?group_level=2&" +
        "startkey=[\"#{ name }\"]&endkey=[\"#{ name }\",{}]&skip=0&limit=#{ limit }"
      json = JSON.parse agent.get(url).body
      json["rows"].length
    end

    private

    # @return mechanize object with html of user profile
    def fetch_user_profile_page(username, agent: URLHelpers.default_agent)
      agent.get("#{ WEB_DOMAIN }/~#{ username }")
    end
  end
end
