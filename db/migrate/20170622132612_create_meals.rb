class CreateMeals < ActiveRecord::Migration[5.1]
  def change
    create_table :meals do |t|
      t.string :code, limit: 9
      t.string :name, limit: 50
      t.integer :priority, limit: 3, default: 0

      t.timestamps
    end
    add_index :meals, :code
    add_index :meals, :priority
  end
end
