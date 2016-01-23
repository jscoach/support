class CreatePackagesTagsJoin < ActiveRecord::Migration
  def change
    create_table :packages_tags, id: false do |t|
      t.integer :package_id, null: false
      t.integer :tag_id, null: false
    end

    add_index :packages_tags, :package_id, unique: true
    add_index :packages_tags, :tag_id, unique: true

    # Don't allow duplicates
    add_index :packages_tags, [:package_id, :tag_id], unique: true
  end
end
