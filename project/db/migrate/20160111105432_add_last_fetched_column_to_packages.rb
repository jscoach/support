class AddLastFetchedColumnToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :last_fetched, :datetime
  end
end
