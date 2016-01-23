class ChangeDownloadColumns < ActiveRecord::Migration
  def change
    # Since packages may not be updated everyday, delete the daily counter for now
    remove_column :packages, :daily_downloads, :integer

    # But add a new one to hold downloads per day since package was created
    add_column :packages, :downloads, :json

    # Rename the columns to make it more obvious what they are
    rename_column :packages, :weekly_downloads, :last_week_downloads
    rename_column :packages, :monthly_downloads, :last_month_downloads
  end
end
