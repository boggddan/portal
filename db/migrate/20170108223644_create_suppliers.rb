class CreateSuppliers < ActiveRecord::Migration[5.0]
  def change
    create_table :suppliers do |t|
      t.string :code, limit: 10
      t.string :name, limit: 50

      t.timestamps
    end
    add_index :suppliers, :code
  end
end
