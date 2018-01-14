class AddIsDelToChildrenCategories < ActiveRecord::Migration[5.1]
  def change
    table_name = :children_categories

    add_column table_name, :is_del, :boolean, default: false, null: false, comment: 'Помітка на видалення'
    add_index table_name, :is_del
    add_index table_name, [ :code ], name: :code_unique, unique: true

    change_column_default( table_name, :code, from: nil, to: '' )
    change_column_default( table_name, :name, from: nil, to: '' )
    change_column_default( table_name, :priority, from: nil, to: 0 )

    change_table_comment( table_name, 'Категорії дітей' )

    change_column_comment( table_name, :id, 'Унікальний ідентифікатор' )
    change_column_comment( table_name, :children_categories_type_id, 'Тип категорії дітей' )
    change_column_comment( table_name, :code, 'Код категорії дитей' )
    change_column_comment( table_name, :name, 'Назва категорії дітей' )
    change_column_comment( table_name, :priority, 'Пріоритет/сортування' )
    change_column_comment( table_name, :created_at, 'Дата створення запису' )
    change_column_comment( table_name, :updated_at, 'Дата останнього оновлення запису' )

    change_column_null( table_name, :children_categories_type_id, false )
    change_column_null( table_name, :code, false )
    change_column_null( table_name, :name, false )
    change_column_null( table_name, :priority, false )
  end
end
