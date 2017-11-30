class AddFieldToProductsMoveProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products_move_products do | t |
      t.decimal :price, precision: 15, scale: 5, default: 0, null: false, comment: 'Ціна'
      t.decimal :balance, precision: 8, scale: 3, default: 0, null: false, comment: 'Залишок продуктів'

      t.index [ :products_move_id, :product_id ], name: :products_move_id_product_id, unique: true
    end
  end
end
