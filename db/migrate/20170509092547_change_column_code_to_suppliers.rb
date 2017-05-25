class ChangeColumnCodeToSuppliers < ActiveRecord::Migration[5.0]
  def change
    change_column :suppliers, :code, :string, limit: 11
  end
end
