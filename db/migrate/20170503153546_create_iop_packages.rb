class CreateIopPackages < ActiveRecord::Migration[5.0]
  def change
    create_table :iop_packages do |t|
      t.belongs_to :institution_order_product, foreign_key: true
      t.belongs_to :suppliers_packages, foreign_key: true
      t.decimal :count, precision: 10, scale: 6

      t.timestamps
    end
  end
end
