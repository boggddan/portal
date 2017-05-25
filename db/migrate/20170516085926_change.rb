class Change < ActiveRecord::Migration[5.0]
  def change
    remove_column :io_corrections, :count
    rename_column :institution_order_products, :count, :amount
    rename_column :io_correction_products, :count_order, :amount_order
    add_column :io_correction_products, :amount, :decimal, precision: 8, scale: 3, default: 0
  end
end
