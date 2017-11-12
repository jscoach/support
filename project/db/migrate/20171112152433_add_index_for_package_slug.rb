class AddIndexForPackageSlug < ActiveRecord::Migration
  def change
    add_index :packages, :slug, unique: true
  end
end
