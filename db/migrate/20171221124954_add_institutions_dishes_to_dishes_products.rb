class AddInstitutionsDishesToDishesProducts < ActiveRecord::Migration[5.1]
  def change
    table_name = :dishes_products

    remove_index table_name, name: :institution_id_dish_id_product_id
    add_reference table_name, :institution_dish, foreign_key: { on_delete: :cascade }, comment: 'Страви підрозділу'
  end
end
