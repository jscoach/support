class CreateFeaturesPackagesJoin < ActiveRecord::Migration
  def change
    create_table :features_packages, id: false do |t|
      t.integer :feature_id, null: false
      t.integer :package_id, null: false
    end

    add_index :features_packages, :feature_id, unique: true
    add_index :features_packages, :package_id, unique: true

    # Don't allow duplicates
    add_index :features_packages, [:feature_id, :package_id], unique: true
  end
end
