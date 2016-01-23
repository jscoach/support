class ChangeTypeLanguagesColumn < ActiveRecord::Migration
  def change
    # This will allow us to store quantity. Eg: { JavaScript: 53295, CoffeeScript: 5072 }
    remove_column :packages, :languages, :string, array: true
    add_column :packages, :languages, :json
  end
end
