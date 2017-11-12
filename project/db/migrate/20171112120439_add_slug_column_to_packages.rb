class AddSlugColumnToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :slug, :string

    Task.new(Package.count) do |progress|
      Package.find_each do |package|
        package.update_column :slug, package.normalize_friendly_id(nil)
        progress.increment! 1
      end
    end

    change_column :packages, :slug, :string, null: false
  end
end
