class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  # Helper method that gives you the path with query string,
  # like `request.fullpath` in Rails
  def current_fullpath
    URI.parse(current_url).request_uri
  end

  # For inputs with debouncing, it may take 300ms to perform actions.
  # For example: The search input updates the URL. If the test changes
  # sorting immediately after filling the search input, the result may
  # not be the expected.
  def fill_in_debounced(*args)
    fill_in *args
    sleep 1
  end
end
