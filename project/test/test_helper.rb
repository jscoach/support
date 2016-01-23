ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun' # Among other things, adds support for mocks and stubs
require 'minitest/metadata'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'custom_expectations'
require 'custom_helpers'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Use the `database_cleaner` gem to clean up the database after each test
  before(:each) { DatabaseCleaner.start }
  after(:each) { DatabaseCleaner.clean }
end

# Load additional methods for all integration specs
class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include MiniTest::Metadata

  # Include test helpers for Authentication
  include Warden::Test::Helpers
  Warden.test_mode!

  before :each do
    Capybara.current_driver = Capybara.javascript_driver if metadata[:js]
  end

  after :each do
    Capybara.current_driver = Capybara.default_driver
  end
end

# Use PhantomJS driver
Capybara.javascript_driver = :poltergeist

# Block remote web requests, since FakeWeb is used to mock all http requests
# But allow requests to local servers (used by the selenium driver for JavaScript tests)
FakeWeb.allow_net_connect = %r[^https?://(?:localhost|127.0.0.1)]

# Compile the assets necessary for running the app.
# Required for integration testing with capybara.
unless ENV['NO_WEBPACK']
  puts "Compiling assets with webpack..."
  `npm run webpack:dev`
end
