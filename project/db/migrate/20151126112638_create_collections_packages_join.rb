class CreateCollectionsPackagesJoin < ActiveRecord::Migration
  def change
    create_table :collections_packages, id: false do |t|
      t.integer :collection_id, null: false
      t.integer :package_id, null: false
    end

    add_index :collections_packages, :collection_id, unique: true
    add_index :collections_packages, :package_id, unique: true

    # Don't allow duplicates
    add_index :collections_packages, [:collection_id, :package_id], unique: true
  end
end
