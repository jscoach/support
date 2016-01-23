class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps null: false
    end

    add_index :features, :name, unique: true
    add_index :features, :slug, unique: true
  end
end
