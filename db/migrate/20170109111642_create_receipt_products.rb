class CreateReceiptProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :receipt_products do |t|
      t.belongs_to :receipt, foreign_key: true
      t.belongs_to :product, foreign_key: true
      t.date :date
      t.decimal :count, precision: 8, scale: 2

      t.timestamps
    end
    add_index :receipt_products, :date
  end
end
