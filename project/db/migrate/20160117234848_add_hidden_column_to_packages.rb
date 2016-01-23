class AddHiddenColumnToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :hidden, :boolean, default: :false
  end
end
