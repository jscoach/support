class AddDependentsColumnToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :dependents, :integer
  end
end
