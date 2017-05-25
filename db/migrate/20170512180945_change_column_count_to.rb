class ChangeColumnCountTo < ActiveRecord::Migration[5.0]
  def change
    change_column :institution_order_products, :count, :decimal, precision: 8, scale: 3, default: 0
    change_column :io_correction_products, :diff, :decimal, precision: 8, scale: 3, default: 0
  end
end
