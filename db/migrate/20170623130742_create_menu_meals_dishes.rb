class CreateMenuMealsDishes < ActiveRecord::Migration[5.1]
  def change
    create_table :menu_meals_dishes do |t|
      t.belongs_to :menu_requirement, foreign_key: true
      t.belongs_to :meal, foreign_key: true
      t.belongs_to :dish, foreign_key: true
      t.boolean :is_enabled, default: false

      t.timestamps
    end
  end
end
