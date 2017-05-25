class CreateInstitutionOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :institution_orders do |t|
      t.belongs_to :institution, foreign_key: true
      t.date :date_start
      t.date :date_end
      t.date :date_sa

      t.timestamps
    end
    add_index :institution_orders, :date_start
    add_index :institution_orders, :date_end
  end
end
