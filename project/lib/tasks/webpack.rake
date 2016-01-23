namespace :webpack do
  desc 'Compile bundles using webpack'
  task :compile do
    output = `npm run webpack:prod`
    output.gsub! /^>.*$/, "" # Remove lines added by `npm run`

    stats = JSON.parse(output)
    browserStats = stats['children'][0]
    manifest = browserStats['assetsByChunkName']

    # Remove assets that are not JavaScript (for eg, our CSS file)
    manifest.each { |k,v| manifest[k] = [v].flatten.find { |s| s =~ /\.js$/ } }

    File.open('./public/assets/webpack-asset-manifest.json', 'w') do |f|
      f.write manifest.to_json
    end
  end
end
