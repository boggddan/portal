class AddFieldsPriceProducts < ActiveRecord::Migration[5.0]
  def change
    add_reference :price_products, :branch, foreign_key: true
    add_reference :price_products, :institution, foreign_key: true
  end
end
