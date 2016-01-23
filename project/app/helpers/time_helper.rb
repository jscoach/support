module TimeHelper
  # Slightly customized `time_ago_in_words` helper
  # @param timestamp must be a Time object
  def relative_timestamp(timestamp)
    str = time_ago_in_words timestamp

    case str
    when /minute|hour/
      "today"
    when /1 day$/
      "yesterday"
    when /30 days$/
      "a month ago"
    when /1 month$/
      "a month ago"
    when /12 months$/
      "a year ago"
    when /1 year$/
      "a year ago"
    when /2 years$/
      "2 years ago"
    when /years$/
      "a long long time ago"
    else
      "#{ str.sub("about ", "") } ago"
    end
  end
end
