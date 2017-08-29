class AddNumberManualToSupplierOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :supplier_orders, :number_manual, :string, limit: 12, default: '', comment: 'Номер документа ручний'

    reversible do | direction |
      # migrate
      direction.up {
        execute <<-SQL.squish
            UPDATE supplier_orders SET number_manual = ''
          SQL
      }
    end
  end

end
