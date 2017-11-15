class Package < ActiveRecord::Base
  module NPMRelated
    extend ActiveSupport::Concern

    # Update the attributes of a package using a given object from NPM
    # @param Object with info from NPM's API
    # NOTE: If a new value is `nil`, the existing value will not be updated
    def assign_npm_attributes(npm)
      self.assign_attributes({
        contributors: npm.contributors,
        dependents: npm.dependents,
        downloads: npm.downloads,
        homepage: npm.homepage,
        keywords: npm.keywords,
        last_month_downloads: npm.last_month_downloads,
        last_week_downloads: npm.last_week_downloads,
        latest_release: npm.latest_release,
        license: npm.license,
        manifest: npm.manifest,
        modified_at: npm.modified_at,
        name: npm.name,
        original_description: npm.description,
        original_repo: npm.repo,
        published_at: npm.published_at
      }.compact)
    end
  end
end
