class AddUniqueIndexToSupplierOrders < ActiveRecord::Migration[5.1]
  def change
    table_name = :supplier_orders

    add_index table_name, [ :number, :date ], name: :number_date_unique, unique: true

    change_column_null( table_name, :number, false )
    change_column_null( table_name, :date, false )
    change_column_null( table_name, :date_start, false )
    change_column_null( table_name, :date_end, false )
    change_column_null( table_name, :is_del_1c, false )
  end
end
