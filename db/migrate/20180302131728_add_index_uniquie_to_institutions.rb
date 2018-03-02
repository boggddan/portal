class AddIndexUniquieToInstitutions < ActiveRecord::Migration[5.1]
  def change
    table_name = :institutions
    change_table_comment( table_name, 'Довідник підрозділів' )

    change_column_null( table_name, :branch_id, false )
    change_column_null( table_name, :code, false )
    change_column_null( table_name, :name, false )
    change_column_null( table_name, :prefix, false )

    change_column_default( table_name, :code, from: nil, to: 0 )
    change_column_default( table_name, :name, from: nil, to: '' )

    change_column_comment( table_name, :id, 'Унікальний ідентифікатор' )
    change_column_comment( table_name, :branch_id, 'Установа' )
    change_column_comment( table_name, :code, 'Код підрозділу' )
    change_column_comment( table_name, :name, 'Назва підрозділу' )
    change_column_comment( table_name, :prefix, 'Префікс для нумерації документів' )
    change_column_comment( table_name, :created_at, 'Дата створення запису' )
    change_column_comment( table_name, :updated_at, 'Дата останнього оновлення запису' )

    add_column table_name, :institution_type_code, :integer, default: 0, null: false, comment: 'Тип підрозділу (1-сад/2-школа)'
    add_index table_name, [ :code ], name: :institutions__code__un, unique: true

    reversible do | direction |
      direction.up {
        execute <<-SQL.squish
            UPDATE #{ table_name } SET institution_type_code = 1
          SQL
      }
    end
  end
end
