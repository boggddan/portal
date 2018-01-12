class AddIsDelToChildrenGroups < ActiveRecord::Migration[5.1]
  def change
    table_name = :children_groups

    add_column table_name, :is_del, :boolean, default: false, null: false, comment: 'Помітка на видалення'
    add_index table_name, :is_del
    # add_index table_name, [ :code ], name: :code_unique, unique: true

    change_column_default( table_name, :code, from: nil, to: '' )
    change_column_default( table_name, :name, from: nil, to:'' )

    change_table_comment( table_name, 'Групи дітей' )

    change_column_comment( table_name, :id, 'Унікальний ідентифікатор' )
    change_column_comment( table_name, :institution_id, 'Підрозділ' )
    change_column_comment( table_name, :children_category_id, 'Категорія дітей' )
    change_column_comment( table_name, :code, 'Номер документа' )
    change_column_comment( table_name, :name, 'Дата документа' )
    change_column_comment( table_name, :created_at, 'Дата створення запису' )
    change_column_comment( table_name, :updated_at, 'Дата останнього оновлення запису' )

    change_column_null( table_name, :institution_id, false )
    change_column_null( table_name, :children_category_id, false )
    change_column_null( table_name, :code, false )
    change_column_null( table_name, :name, false )
  end
end
