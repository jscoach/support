class AddDefaultColumnToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :default, :boolean, default: :true
  end
end
