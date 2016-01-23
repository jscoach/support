class RenameFeaturesToFilters < ActiveRecord::Migration
  def change
    rename_table :features, :filters
    rename_table :features_packages, :filters_packages
    rename_column :filters_packages, :feature_id, :filter_id
  end
end
