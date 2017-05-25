class CreatePackages < ActiveRecord::Migration[5.0]
  def change
    create_table :packages do |t|
      t.string :code, limit: 9
      t.string :name, limit: 100
      t.decimal :conversion_factor, precision: 10, scale: 6

      t.timestamps
    end
    add_index :packages, :code
  end
end
