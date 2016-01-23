require "test_helper"

class NumberHelperTest < ActionView::TestCase
  it "returns a short humanized number" do
    humanized_number(0).must_equal "0"
    humanized_number(123).must_equal "123"

    humanized_number(1_049).must_equal "1K"
    humanized_number(1_499).must_equal "1.5K"

    humanized_number(12_049).must_equal "12K"
    humanized_number(12_499).must_equal "12K"

    humanized_number(123_049).must_equal "123K"
    humanized_number(123_499).must_equal "123K"

    humanized_number(1_049_999).must_equal "1M"
    humanized_number(1_499_999).must_equal "1.5M"

    humanized_number(12_049_999).must_equal "12M"
    humanized_number(12_499_999).must_equal "12M"

    humanized_number(123_049_999).must_equal "123M"
    humanized_number(123_499_999).must_equal "123M"

    humanized_number(1_049_999_999).must_equal "1B"
    humanized_number(1_499_999_999).must_equal "1.5B"

    humanized_number(12_049_999_999).must_equal "12B"
    humanized_number(12_499_999_999).must_equal "12B"

    humanized_number(123_049_999_999).must_equal "123B"
    humanized_number(123_499_999_999).must_equal "123B"

    humanized_number(1_049_999_999_999).must_equal "1T"
    humanized_number(1_499_999_999_999).must_equal "1.5T"

    humanized_number(12_049_999_999_999).must_equal "12T"
    humanized_number(12_499_999_999_999).must_equal "12T"

    humanized_number(123_049_999_999_999).must_equal "123T"
    humanized_number(123_499_999_999_999).must_equal "123T"

    humanized_number(1_049_999_999_999_999).must_equal "1Q"
    humanized_number(1_499_999_999_999_999).must_equal "1.5Q"
  end
end
