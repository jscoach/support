# Webpack config based on: http://clarkdave.net/2015/01/how-to-use-webpack-with-rails/

if Rails.configuration.webpack[:use_manifest]
  asset_manifest = File.join(Rails.root, 'public', 'assets', 'webpack-asset-manifest.json')
  common_manifest = File.join(Rails.root, 'public', 'assets', 'webpack-common-manifest.json')

  if File.exist?(asset_manifest)
    Rails.configuration.webpack[:asset_manifest] = JSON.parse(
      File.read(asset_manifest),
    ).with_indifferent_access
  end

  if File.exist?(common_manifest)
    Rails.configuration.webpack[:common_manifest] = JSON.parse(
      File.read(common_manifest),
    ).with_indifferent_access
  end
end
