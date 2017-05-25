class CreateSupplierOrderProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :supplier_order_products do |t|
      t.belongs_to :supplier_order, foreign_key: true
      t.belongs_to :institution, foreign_key: true
      t.belongs_to :product, foreign_key: true
      t.string :contract_number, limit: 12
      t.date :date
      t.decimal :count, precision: 8, scale: 2

      t.timestamps
    end
    add_index :supplier_order_products, :contract_number
    add_index :supplier_order_products, :date
  end
end
