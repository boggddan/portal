class AddContractNumberManualToReceipts < ActiveRecord::Migration[5.1]
  def change
    add_column :receipts, :contract_number_manual, :string, limit: 12, default: '', comment: 'Номер договора ручний'

    reversible do | direction |
      # migrate
      direction.up {
        execute <<-SQL.squish
            UPDATE receipts SET contract_number_manual = contract_number
          SQL
      }
    end
  end
end
