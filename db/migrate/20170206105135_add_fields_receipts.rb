class AddFieldsReceipts < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :number, :string, limit: 12
    add_index :receipts, :number
  end
end
