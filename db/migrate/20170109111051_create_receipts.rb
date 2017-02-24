class CreateReceipts < ActiveRecord::Migration[5.0]
  def change
    create_table :receipts do |t|
      t.belongs_to :supplier_order, foreign_key: true
      t.belongs_to :institution, foreign_key: true
      t.string :contract_number, limit: 12
      t.string :invoice_number, limit: 12
      t.date :date
      t.date :date_sa

      t.timestamps
    end
    add_index :receipts, :contract_number
    add_index :receipts, :date
  end
end
