class ChangeCodeToProducts < ActiveRecord::Migration[5.0]
  def change
    change_column :products, :code, :string, limit: 11
  end
end
