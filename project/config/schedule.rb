# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

# Get the rails env from the environment variable, or default to development
set :environment, ENV.fetch('RAILS_ENV', 'development')

set :output, "#{ path }/log/cron.log"

every :day, at: "13pm" do
  rake "app:npm_update_new"
end

every 2.hours do
  rake "app:npm_update"
end

every 1.hour do
  rake "app:tweet"
end

# Check if the cron job was configured correctly with `crontab -l`
