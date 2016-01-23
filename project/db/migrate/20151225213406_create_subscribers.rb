class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :email, null: false

      t.timestamps null: false
    end
  end
end
