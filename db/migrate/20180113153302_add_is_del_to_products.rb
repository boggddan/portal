class AddIsDelToProducts < ActiveRecord::Migration[5.1]
  def change
    table_name = :products

    add_column table_name, :is_del, :boolean, default: false, null: false, comment: 'Помітка на видалення'
    add_index table_name, :is_del
    # add_index table_name, [ :code ], name: :code_unique, unique: true

    change_column_default( table_name, :code, from: nil, to: '' )
    change_column_default( table_name, :name, from: nil, to: '' )

    change_table_comment( table_name, 'Продукти харчування' )

    change_column_comment( table_name, :id, 'Унікальний ідентифікатор' )
    change_column_comment( table_name, :products_type_id, 'Тип продукта харчування' )
    change_column_comment( table_name, :code, 'Код продукта' )
    change_column_comment( table_name, :name, 'Назва продукта' )
    change_column_comment( table_name, :created_at, 'Дата створення запису' )
    change_column_comment( table_name, :updated_at, 'Дата останнього оновлення запису' )

    change_column_null( table_name, :products_type_id, false )
    change_column_null( table_name, :code, false )
    change_column_null( table_name, :name, false )
  end
end
