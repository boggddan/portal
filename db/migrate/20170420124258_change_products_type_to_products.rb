class ChangeProductsTypeToProducts < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :products_type
  end
end
