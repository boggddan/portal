class AddCountOrderToReceiptProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :receipt_products, :count_order, :decimal, precision: 8, scale: 3, default: 0
  end
end
