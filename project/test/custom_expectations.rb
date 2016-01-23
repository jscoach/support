module MiniTest::Assertions
  def assert_url_equals(str0, str1)
    assert sorted(str0) == sorted(str1), "Expected URL `#{str0}` to match `#{str1}`"
  end

  private

  # Sort a string. Useful to compare URLs since the order of query params may vary.
  def sorted(str)
    str.chars.sort.join
  end
end

String.infect_an_assertion :assert_url_equals, :url_must_equal
