namespace :app do
  namespace :npm_file_download do
    def config
      Rails.configuration.app
    end

    desc "Pull the names of packages published on npm since the beginning of time"
    task :all do |t|
      `curl -L #{ config.npm.api.all } -o #{ config.npm.filename }`
    end
  end
end
