class CreateProductsTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :products_types do |t|
      t.string :code, limit: 9
      t.string :name, limit: 100
      t.integer :priority, limit: 3

      t.timestamps
    end
    add_index :products_types, :code
    add_index :products_types, :priority
  end
end
