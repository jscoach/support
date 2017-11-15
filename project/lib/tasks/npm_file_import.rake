require 'task_helper'

namespace :app do
  def config
    Rails.configuration.app
  end

  desc "Import downloaded NPM package names to our database as `pending`"
  task :npm_file_import => :environment do |t|
    data = JSON.parse File.read(config.npm.filename)

    Task.new(data.size) do |progress|
      data.each do |name|
        begin
          Package.find_or_create_by(name: name)
          progress.increment! 1
        rescue SystemExit, Interrupt, Octokit::RateLimit
          JsCoach.warn "Task interrupted!"
          exit
        rescue => e
          JsCoach.error e.to_s
          ExceptionNotifier.notify_exception(e) # Send backtrace
          exit
        end
      end
    end
  end
end
