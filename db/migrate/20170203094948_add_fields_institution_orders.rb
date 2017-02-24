class AddFieldsInstitutionOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :institution_orders, :number, :string, limit: 12
    add_column :institution_orders, :date, :date
    add_column :institution_orders, :number_sa, :string, limit: 12

    add_index :institution_orders, :number
    add_index :institution_orders, :date
  end
end
