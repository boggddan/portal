class CreateTimesheets < ActiveRecord::Migration[5.0]
  def change
    create_table :timesheets do |t|
      t.belongs_to :branch, foreign_key: true
      t.belongs_to :institution, foreign_key: true
      t.string :number, limit: 12
      t.date :date
      t.date :date_sa
      t.string :number_sa, limit: 12
      t.string :number_sa, limit: 12
      t.date :date_vb
      t.date :date_ve
      t.date :date_eb
      t.date :date_ee

      t.timestamps
    end
    add_index :timesheets, :number
    add_index :timesheets, :date
  end
end
