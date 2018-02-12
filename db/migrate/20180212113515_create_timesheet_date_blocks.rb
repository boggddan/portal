class CreateTimesheetDateBlocks < ActiveRecord::Migration[5.1]
  def change
    table_name = :timesheet_date_blocks

    create_table table_name, comment: 'Дата блокування документів табелю' do | t |
      t.belongs_to :institution, foreign_key: { on_delete: :cascade }, null: false, comment: 'Підрозділ'
      t.date :date, null: false, default: -> { 'CURRENT_TIMESTAMP' }, comment: 'Дата'

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }

      t.index [ :institution_id, :date ], name: :tdb_institution_id_date, unique: true
    end

    reversible do |direction|
      direction.up {
        execute <<-SQL.squish
            CREATE TRIGGER #{ table_name }_update_at
              BEFORE UPDATE ON #{ table_name }
                FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp()
          SQL
      }
    end

    change_column_comment( table_name, :created_at, 'Дата створення запису' )
    change_column_comment( table_name, :updated_at, 'Дата останнього оновлення запису' )
  end
end
