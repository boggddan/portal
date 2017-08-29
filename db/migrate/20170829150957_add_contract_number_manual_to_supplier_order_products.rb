class AddContractNumberManualToSupplierOrderProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :supplier_order_products, :contract_number_manual, :string, limit: 12, default: '', comment: 'Номер договора ручний'

    reversible do | direction |
      # migrate
      direction.up {
        execute <<-SQL.squish
            UPDATE supplier_order_products SET contract_number_manual = ''
          SQL
      }
    end
  end
end
