class CreateSupplierOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :supplier_orders do |t|
      t.belongs_to :branch, foreign_key: true
      t.belongs_to :supplier, foreign_key: true
      t.string :number, limit: 12
      t.date :date
      t.date :date_start
      t.date :date_end

      t.timestamps
    end
    add_index :supplier_orders, :number
    add_index :supplier_orders, :date
  end
end
