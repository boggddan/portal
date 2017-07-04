class AddMenuMealsDishToMenuProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :menu_products, :menu_meals_dish, foreign_key: true
  end
end
