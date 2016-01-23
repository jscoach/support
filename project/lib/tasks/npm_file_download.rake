namespace :app do
  namespace :npm_file_download do
    def config
      Rails.configuration.app
    end

    # Uniformize the data downloaded from NPM
    # @return Array of hashes
    def convert(json)
      # The data may be an array of metadata, in the case of the `yesterday`
      # or `today` APIs, or an object where the values are the metadata.
      json = json.values unless json.is_a? Array

      # Remove weird junk that is not metadata
      json.select { |package| package.is_a? Hash }
    end

    def convert_file(filename)
      input = JSON.parse File.read(filename)
      output = JSON.pretty_generate convert(input)
      File.write(filename, output)
    end

    desc "Pull packages published on NPM since yesterday"
    task :yesterday do |t|
      `curl -L #{ config.npm.api.yesterday } -o #{ config.npm.filename }`
      convert_file(config.npm.filename)
    end

    desc "Pull packages published on NPM today"
    task :today do |t|
      `curl -L #{ config.npm.api.today } -o #{ config.npm.filename }`
      convert_file(config.npm.filename)
    end

    desc "Pull packages published on npm since the beginning of time"
    task :all do |t|
      `curl -L #{ config.npm.api.all } -o #{ config.npm.filename }`
      convert_file(config.npm.filename)
    end
  end
end
