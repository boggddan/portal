class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :code, limit: 9
      t.string :name, limit: 50

      t.timestamps
    end
    add_index :products, :code
  end
end
