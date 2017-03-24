class ChangeColumnNameToProducts < ActiveRecord::Migration[5.0]
  def change
    change_column :products, :name, :string, limit: 100
  end
end
