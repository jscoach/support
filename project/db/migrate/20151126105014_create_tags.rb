class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps null: false
    end

    add_index :tags, :name, unique: true
    add_index :tags, :slug, unique: true
  end
end
