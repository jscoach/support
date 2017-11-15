require 'task_helper'

namespace :app do
  desc "Downloads all packages and updates the new ones"
  task :npm_update_new => :environment do |t, args|
    Rake::Task["app:npm_file_download:all"].invoke
    Rake::Task["app:npm_file_import"].invoke
    Rake::Task["app:npm_update"].invoke "new"
  end

  desc "Update metadata (like version and stars) of packages"
  task :npm_update, [ :new ] => :environment do |t, args|
    packages = Package.without_state(:rejected)
    started_at = Time.now

    if args[:new].blank?
      # If a param is not provided, update packages with collections that have
      # not been updated the longest for 1 hour
      packages = packages.with_collections.order("packages.updated_at asc").limit(1000)
    else
      # If a param is provided, update packages created recently
      packages = packages.where("packages.created_at >= ?", Time.now.beginning_of_day - 1.day)
    end

    Task.new(packages.count) do |progress|
      packages.each do |package|
        begin
          begin
            # Pass `repo` to prevent GitHub service from trying to find it again,
            # in case it is not defined in the package.json
            hash = { name: package.name, custom_repo: package.repo }

            npm = NPM::Package.new(hash, fetch: true)
            github = Github::Repository.new(npm, fetch: true)

            package.assign_npm_attributes(npm)
            package.assign_github_attributes(github)
            package.last_fetched = Time.now

          rescue Github::RepoNotFound => e
            JsCoach.info "The repository for #{ package.name } could not be found (#{ e })."
          rescue Octokit::NotFound => e
            JsCoach.info "The repository for #{ package.name } could not be found (#{ e })."
          rescue Octokit::InvalidRepository => e
            JsCoach.warn "Invalid repository for #{ package.name }."
          end

          unless package.auto_review.save
            errors = package.errors.full_messages.join('; ')
            JsCoach.warn "#{ package.name } not updated because: #{ errors }"
          end

          if args[:new].blank? and package.rejected?
            JsCoach.warn "The existing #{ package.name } package was rejected."
          end

          package.touch

        rescue Mechanize::ResponseCodeError => e
          package.touch
          JsCoach.info "The NPM package for #{ package.name } could not be found in the registry (#{ e })."
        rescue SystemExit, Interrupt, Octokit::RateLimit
          JsCoach.warn "Task interrupted!"
          exit
        rescue => e
          JsCoach.error e.to_s
          ExceptionNotifier.notify_exception(e) # Send backtrace
          exit
        end

        progress.increment! 1

        if args[:new].blank? and Time.now - started_at > 55*60
          JsCoach.info "This task already took 55 minutes, exiting..."
          break
        end

      end
    end
  end
end
