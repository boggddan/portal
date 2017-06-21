class AddIsDel1cToAllDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :institution_orders, :is_del_1c, :boolean, default: false
    add_column :io_corrections, :is_del_1c, :boolean, default: false
    add_column :menu_requirements, :is_del_1c, :boolean, default: false
    add_column :timesheets, :is_del_1c, :boolean, default: false
    add_column :supplier_orders, :is_del_1c, :boolean, default: false
    add_column :receipts, :is_del_1c, :boolean, default: false
  end
end
