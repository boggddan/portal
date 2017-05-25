class CreateSuppliersPackages < ActiveRecord::Migration[5.0]
  def change
    create_table :suppliers_packages do |t|
      t.belongs_to :institution, foreign_key: true
      t.belongs_to :supplier, foreign_key: true
      t.belongs_to :product, foreign_key: true
      t.belongs_to :package, foreign_key: true
      t.date :period
      t.boolean :activity

      t.timestamps
    end
    add_index :suppliers_packages, :activity
  end
end
