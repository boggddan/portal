class CreatePriceProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :price_products do |t|
      t.belongs_to :product, foreign_key: true
      t.date :price_date
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
    add_index :price_products, :price_date
  end
end
