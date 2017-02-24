class CreateTimesheetDates < ActiveRecord::Migration[5.0]
  def change
    create_table :timesheet_dates do |t|
      t.belongs_to :timesheet, foreign_key: true
      t.belongs_to :children_group, foreign_key: true
      t.belongs_to :child, foreign_key: true
      t.belongs_to :reasons_absence, foreign_key: true
      t.date :date

      t.timestamps
    end
    add_index :timesheet_dates, :date
  end
end
