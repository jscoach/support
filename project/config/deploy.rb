# config valid only for Capistrano 3.4
lock '3.4.0'

set :application, 'jscoach'
set :repo_url, ENV["REPO_URL"]
set :repo_tree, 'project' # Relative path to project root in repo

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, ENV["SERVER_DIR"]

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Instead of compiling assets on the server, we will do this locally. This allows us
# to not install webpack and all its dependencies on the production web servers.
# Based on: gist.github.com/66de336327f79beac0e0
#
# Clear existing task so we can replace it rather than "add" to it.
Rake::Task["deploy:compile_assets"].clear

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'Compile assets'
  task compile_assets: [:set_rails_env] do
    invoke 'deploy:assets:precompile_local'
    invoke 'deploy:assets:backup_manifest'
  end

  namespace :assets do
    desc "Precompile assets locally and then rsync to web servers"
    task :precompile_local do
      app_assets_dir = "./app/assets/"
      public_assets_dir = "./public/assets/"

      # Clean up
      run_locally do
        execute "rm -rf #{ app_assets_dir }"
        execute "rm -rf #{ public_assets_dir }"
      end

      # Compile assets locally
      run_locally do
        execute "RAILS_ENV=#{ fetch(:stage) } bundle exec rake webpack:compile"
        execute "RAILS_ENV=#{ fetch(:stage) } bundle exec rake assets:precompile"
      end

      # Sync to each server
      on roles(fetch(:assets_roles, [:web])) do
        remote_dir = "#{ host.user }@#{ host.hostname }:#{ release_path }"
        run_locally do
          execute "rsync -av --delete #{ public_assets_dir } #{ remote_dir }/public/assets/"
          execute "rsync -av --delete ./server-bundle.js #{ remote_dir }/server-bundle.js"
        end
      end

      # Clean up
      run_locally do
        execute "rm -rf #{ app_assets_dir }"
        execute "rm -rf #{ public_assets_dir }"
      end
    end
  end
end
