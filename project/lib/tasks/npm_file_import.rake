require 'task_helper'

namespace :app do
  def config
    Rails.configuration.app
  end

  desc "Import packages downloaded from NPM to our database as `pending`"
  task :npm_file_import => :environment do |t|
    data = JSON.parse File.read(config.npm.filename)

    Task.new(data.size) do |progress|
      data.each do |json|
        begin
          npm = NPM::Package.new(json)

          package = Package.find_or_initialize_by(name: npm.name)
          package.assign_npm_attributes(npm)

          unless package.auto_transition.save
            errors = package.errors.full_messages.join('; ')
            JsCoach.warn "#{ package.name } not imported because: #{ errors }"
          end

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
