class FixConstraintOfRelationshipsIndexes < ActiveRecord::Migration
  def change
    # Remove unique constraints
    remove_index :collections_packages, :collection_id
    remove_index :collections_packages, :package_id
    add_index :collections_packages, :collection_id
    add_index :collections_packages, :package_id

    remove_index :packages_tags, :package_id
    remove_index :packages_tags, :tag_id
    add_index :packages_tags, :package_id
    add_index :packages_tags, :tag_id

    remove_index :features_packages, :feature_id
    remove_index :features_packages, :package_id
    add_index :features_packages, :feature_id
    add_index :features_packages, :package_id
  end
end
