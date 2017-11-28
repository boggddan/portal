class DropProductPrices < ActiveRecord::Migration[5.1]
  def change
    drop_table :price_products
  end
end
