class CreateInstitutionOrderProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :institution_order_products do |t|
      t.belongs_to :institution_order, foreign_key: true
      t.belongs_to :product, foreign_key: true
      t.date :date
      t.decimal :count, precision: 8, scale: 2
      t.string :description, limit: 100

      t.timestamps
    end
    add_index :institution_order_products, :date
  end
end
