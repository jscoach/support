# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << File.join(Rails.root, "app", "assets")
Rails.application.config.assets.paths << File.join(Rails.root, "node_modules")
Rails.application.config.assets.paths << File.join(Rails.root, "app", "frontend", "images")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( search.svg jscoach.svg jess.png jess-levelup.png ) +
  %w( base.css app.css common-bundle.js app-bundle.js accounts-bundle.js )

# Add the client for webpack-dev-server to enable hot reload
Rails.application.config.assets.precompile += %w( dev-client-bundle.js ) if Rails.env.development?
