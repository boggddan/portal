class AddIndexMenuRequirements < ActiveRecord::Migration[5.1]
  def change
    add_index :menu_requirements, [ :institution_id, :number ], name: :institution_id_number, unique: true
    add_index :menu_meals_dishes, [ :menu_requirement_id, :meal_id, :dish_id ], name: :menu_requirement_id_meal_id_dish_id, unique: true
    add_index :menu_children_categories, [ :menu_requirement_id, :children_category_id ], name: :menu_requirement_id_children_category_id, unique: true
    add_index :menu_products, [ :menu_meals_dish_id, :children_category_id, :product_id ], name: :menu_meals_dish_id_children_category_id_product_id, unique: true
  end
end
