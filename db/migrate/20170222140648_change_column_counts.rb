class ChangeColumnCounts < ActiveRecord::Migration[5.0]
  def change
    change_column :institution_order_products, :count, :decimal, precision: 8, scale: 3
    change_column :menu_products, :count_fact, :decimal, precision: 8, scale: 3
    change_column :menu_products, :count_plan, :decimal, precision: 8, scale: 3
    change_column :supplier_order_products, :count, :decimal, precision: 8, scale: 3
  end
end
