class NonUniqueNameAndSlugForFilters < ActiveRecord::Migration
  def change
    # Remove the current indexes that force uniqueness
    remove_index :filters, column: :name
    remove_index :filters, column: :slug

    add_index :filters, :name, unique: false
    add_index :filters, :slug, unique: false

    # The slug and name are not unique, only when combinated with the collection
    add_index :filters, [:name, :collection_id], unique: true
    add_index :filters, [:slug, :collection_id], unique: true
  end
end
