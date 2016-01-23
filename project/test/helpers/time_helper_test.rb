require "test_helper"

class TimeHelperTest < ActionView::TestCase
  it "returns a relative time" do
    relative_timestamp(Time.now).must_equal "today"
    relative_timestamp(1.hour.ago).must_equal "today"

    relative_timestamp(24.hours.ago).must_equal "yesterday"
    relative_timestamp(1.day.ago).must_equal "yesterday"

    relative_timestamp(2.days.ago).must_equal "2 days ago"

    relative_timestamp(30.days.ago).must_equal "a month ago"
    relative_timestamp(1.month.ago).must_equal "a month ago"
    relative_timestamp(1.month.ago + 1.minute).must_equal "a month ago" # `time_ago_in_words` returns "30 days"

    relative_timestamp(2.months.ago).must_equal "2 months ago"

    relative_timestamp(12.months.ago).must_equal "a year ago"
    relative_timestamp(1.year.ago).must_equal "a year ago"
    relative_timestamp(1.year.ago + 1.minute).must_equal "a year ago" # `time_ago_in_words` returns "12 months"

    relative_timestamp(2.years.ago).must_equal "2 years ago"
    relative_timestamp(2.years.ago - 6.months).must_equal "2 years ago"

    relative_timestamp(3.years.ago).must_equal "a long long time ago"
  end
end
