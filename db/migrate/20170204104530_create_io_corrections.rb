class CreateIoCorrections < ActiveRecord::Migration[5.0]
  def change
    create_table :io_corrections do |t|
      t.belongs_to :institution_order, foreign_key: true
      t.string :number, limit: 12
      t.date :date
      t.date :date_sa
      t.string :number_sa, limit: 12

      t.timestamps
    end
    add_index :io_corrections, :number
    add_index :io_corrections, :date
  end
end
