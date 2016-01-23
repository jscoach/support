require 'progress_bar'

class AddPackageDownloadColumns < ActiveRecord::Migration
  def change
    add_column :packages, :total_downloads, :integer, null: false, default: 0
    add_column :packages, :downloads_svg, :text, null: false, default: ""

    packages = Package.with_state(:accepted)

    progress_bar = ProgressBar.new(packages.count) if packages.count > 0

    # Run the `before_save` to update existing data
    packages.each do |p|
      p.send :update_total_downloads
      p.send :update_downloads_svg
      p.save!

      progress_bar.increment! 1
    end
  end
end
