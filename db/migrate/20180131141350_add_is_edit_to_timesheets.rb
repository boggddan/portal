class AddIsEditToTimesheets < ActiveRecord::Migration[5.1]
  def change
    add_column :timesheets, :is_edit, :boolean, default: true, null: false, comment: 'Режим редагування'

    reversible do | direction |
      direction.up {
        execute <<-SQL.squish
            update timesheets set is_edit = true;
            update timesheets set is_edit = false where number_sa != '' and number_sa is not null ;
          SQL
      }
    end

  end
end
