module URLHelpers
  extend self

  def default_agent
    Mechanize.new do |a|
      a.follow_meta_refresh = true
    end
  end
end
