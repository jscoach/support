class AddWhitelistedColumnToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :whitelisted, :boolean, default: false
  end
end
