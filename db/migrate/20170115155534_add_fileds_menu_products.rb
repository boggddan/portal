class AddFiledsMenuProducts < ActiveRecord::Migration[5.0]
  def change
    rename_column :menu_products, :count, :count_plan
    add_column :menu_products, :count_fact, :decimal, precision: 8, scale: 2

    change_column_default :menu_products, :count_plan, 0
    change_column_default :menu_products, :count_fact, 0
  end
end
