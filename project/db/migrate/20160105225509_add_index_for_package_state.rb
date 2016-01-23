class AddIndexForPackageState < ActiveRecord::Migration
  def change
    add_index :packages, :state
  end
end
