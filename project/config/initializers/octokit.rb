# Provide authentication credentials
Octokit.configure do |c|
  c.login = Rails.application.secrets.github_username
  c.password = Rails.application.secrets.github_password || ""
end

# For smallish resource lists, Octokit provides auto pagination. When this is enabled,
# calls for paginated resources will fetch and concatenate the results from every page
# into a single array
Octokit.auto_paginate = true
