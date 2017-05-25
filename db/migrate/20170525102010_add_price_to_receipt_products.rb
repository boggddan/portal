class AddPriceToReceiptProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :receipt_products, :price, :decimal, precision: 15, scale: 5, default: 0
  end
end
