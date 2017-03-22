class AddFieldToReceiptProducts < ActiveRecord::Migration[5.0]
  def change
    change_column :receipt_products, :count, :decimal, precision: 8, scale: 3, default: 0, null: false
    add_column :receipt_products, :count_invoice, :decimal, precision: 8, scale: 3, default: 0, null: false
    add_reference :receipt_products, :causes_deviation
  end
end
