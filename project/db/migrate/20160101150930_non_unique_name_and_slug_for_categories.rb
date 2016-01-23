class NonUniqueNameAndSlugForCategories < ActiveRecord::Migration
  def change
    # Remove the current indexes that force uniqueness
    remove_index :categories, column: :name
    remove_index :categories, column: :slug

    add_index :categories, :name, unique: false
    add_index :categories, :slug, unique: false

    # The slug and name are not unique, only when combinated with the collection
    add_index :categories, [:name, :collection_id], unique: true
    add_index :categories, [:slug, :collection_id], unique: true
  end
end
