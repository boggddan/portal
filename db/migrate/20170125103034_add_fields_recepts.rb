class AddFieldsRecepts < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :number_sa, :string, limit: 12
  end
end
