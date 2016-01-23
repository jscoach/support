class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name, null: false
      t.string :state, null: false

      t.string :repo
      t.string :original_repo
      t.string :keywords, array: true

      t.text :description
      t.text :original_description

      t.string :latest_release
      t.datetime :modified_at
      t.datetime :published_at

      t.string :license
      t.string :homepage

      t.integer :daily_downloads
      t.integer :weekly_downloads
      t.integer :monthly_downloads

      t.integer :stars
      t.string :languages, array: true
      t.text :readme
      t.boolean :is_fork

      t.json :manifest
      t.json :contributors

      t.timestamps null: false
    end

    add_index :packages, :name, unique: true
  end
end
