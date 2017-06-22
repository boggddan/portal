class CreateDishes < ActiveRecord::Migration[5.1]
  def change
    create_table :dishes do |t|
      t.belongs_to :dishes_category, foreign_key: true
      t.string :code, limit: 9
      t.string :name, limit: 50
      t.integer :priority, limit: 3, default: 0

      t.timestamps
    end
    add_index :dishes, :code
    add_index :dishes, :priority
  end
end
