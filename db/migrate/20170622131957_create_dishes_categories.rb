class CreateDishesCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :dishes_categories do |t|
      t.string :code, limit: 9
      t.string :name, limit: 50
      t.integer :priority, limit: 3, default: 0

      t.timestamps
    end
    add_index :dishes_categories, :code
    add_index :dishes_categories, :priority
  end
end
