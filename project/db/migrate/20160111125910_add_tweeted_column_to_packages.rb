class AddTweetedColumnToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :tweeted, :boolean, default: false

    # Mark all existing published packages as tweeted, except the last 20
    Package.with_state(:published).update_all(tweeted: true)
    Package.with_state(:published).order("published_at desc").limit(24).update_all(tweeted: false)
  end
end
