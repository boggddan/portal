class AddDefaultValueFromDocuments < ActiveRecord::Migration[5.1]
  def change
    # menu_requirements
    change_column_null( :menu_requirements, :branch_id, false )
    change_column_null( :menu_requirements, :institution_id, false )

    change_column_default( :menu_requirements, :number, from: nil, to: '' )
    change_column_default( :menu_requirements, :number_sap, from: nil, to:'' )
    change_column_default( :menu_requirements, :number_saf, from: nil, to: '' )
    change_column_default( :menu_requirements, :date, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :menu_requirements, :splendingdate, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :menu_requirements, :date_sap, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :menu_requirements, :date_saf, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )

    change_table_comment( :menu_requirements, 'Меню-вимога' )

    change_column_comment( :menu_requirements, :id, 'Унікальний ідентифікатор' )
    change_column_comment( :menu_requirements, :branch_id, 'Установа' )
    change_column_comment( :menu_requirements, :institution_id, 'Підрозділ' )
    change_column_comment( :menu_requirements, :number, 'Номер документа' )
    change_column_comment( :menu_requirements, :date, 'Дата документа' )
    change_column_comment( :menu_requirements, :number_sap, 'Номер документа ІС план' )
    change_column_comment( :menu_requirements, :number_saf, 'Номер документа ІС факт' )
    change_column_comment( :menu_requirements, :splendingdate, 'Дата списання' )
    change_column_comment( :menu_requirements, :date_sap, 'Дата документа ІС план' )
    change_column_comment( :menu_requirements, :date_saf, 'Дата документа ІС факт' )
    change_column_comment( :menu_requirements, :is_del_plan_1c, 'Ознака видалення ІС плана' )
    change_column_comment( :menu_requirements, :is_del_fact_1c, 'Ознака видалення ІС факта' )
    change_column_comment( :menu_requirements, :created_at, 'Дата створення запису' )
    change_column_comment( :menu_requirements, :updated_at, 'Дата останнього оновлення запису' )

    # institution_orders
    change_column_null( :institution_orders, :institution_id, false )

    change_column_default( :institution_orders, :number, from: nil, to: '' )
    change_column_default( :institution_orders, :number_sa, from: nil, to:'' )
    change_column_default( :institution_orders, :date, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :institution_orders, :date_sa, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :institution_orders, :date_start, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :institution_orders, :date_end, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )

    change_table_comment( :institution_orders, 'Замовлення продуктів харчування' )

    change_column_comment( :institution_orders, :id, 'Унікальний ідентифікатор' )
    change_column_comment( :institution_orders, :institution_id, 'Підрозділ' )
    change_column_comment( :institution_orders, :number, 'Номер документа' )
    change_column_comment( :institution_orders, :date, 'Дата документа' )
    change_column_comment( :institution_orders, :number_sa, 'Номер документа ІС' )
    change_column_comment( :institution_orders, :date_sa, 'Дата документа ІС' )
    change_column_comment( :institution_orders, :is_del_1c, 'Ознака видалення ІС' )
    change_column_comment( :institution_orders, :created_at, 'Дата створення запису' )
    change_column_comment( :institution_orders, :updated_at, 'Дата останнього оновлення запису' )

    change_column_comment( :institution_orders, :date_start, 'Дата початку періоду замовлення' )
    change_column_comment( :institution_orders, :date_end, 'Дата кінця періоду замовлення' )

    # io_corrections
    change_column_null( :io_corrections, :institution_order_id, false )

    change_column_default( :io_corrections, :number, from: nil, to: '' )
    change_column_default( :io_corrections, :number_sa, from: nil, to:'' )
    change_column_default( :io_corrections, :date, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :io_corrections, :date_sa, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )

    change_table_comment( :io_corrections, 'Коригування замовлення продуктів харчування' )

    change_column_comment( :io_corrections, :id, 'Унікальний ідентифікатор' )
    change_column_comment( :io_corrections, :institution_order_id, 'Замовлення продуктів харчування' )
    change_column_comment( :io_corrections, :number, 'Номер документа' )
    change_column_comment( :io_corrections, :date, 'Дата документа' )
    change_column_comment( :io_corrections, :number_sa, 'Номер документа ІС' )
    change_column_comment( :io_corrections, :date_sa, 'Дата документа ІС' )
    change_column_comment( :io_corrections, :is_del_1c, 'Ознака видалення ІС' )
    change_column_comment( :io_corrections, :created_at, 'Дата створення запису' )
    change_column_comment( :io_corrections, :updated_at, 'Дата останнього оновлення запису' )

    # receipts
    change_column_null( :receipts, :supplier_order_id, false )
    change_column_null( :receipts, :institution_id, false )

    change_column_default( :receipts, :number, from: nil, to: '' )
    change_column_default( :receipts, :number_sa, from: nil, to:'' )
    change_column_default( :receipts, :contract_number, from: nil, to:'' )
    change_column_default( :receipts, :invoice_number, from: nil, to:'' )

    change_column_default( :receipts, :date, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :receipts, :date_sa, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )

    change_table_comment( :receipts, 'Надходження ТМЦ' )

    change_column_comment( :receipts, :id, 'Унікальний ідентифікатор' )
    change_column_comment( :receipts, :supplier_order_id, 'Замовлення постачальнику' )
    change_column_comment( :receipts, :institution_id, 'Підрозділ' )
    change_column_comment( :receipts, :number, 'Номер документа' )
    change_column_comment( :receipts, :date, 'Дата документа' )
    change_column_comment( :receipts, :number_sa, 'Номер документа ІС' )
    change_column_comment( :receipts, :date_sa, 'Дата документа ІС' )
    change_column_comment( :receipts, :is_del_1c, 'Ознака видалення ІС' )
    change_column_comment( :receipts, :created_at, 'Дата створення запису' )
    change_column_comment( :receipts, :updated_at, 'Дата останнього оновлення запису' )

    change_column_comment( :receipts, :contract_number, 'Номер договору постачання' )
    change_column_comment( :receipts, :invoice_number, 'Номер накладної' )

    # timesheets
    change_column_null( :timesheets, :branch_id, false )
    change_column_null( :timesheets, :institution_id, false )

    change_column_default( :timesheets, :number, from: nil, to: '' )
    change_column_default( :timesheets, :number_sa, from: nil, to:'' )

    change_column_default( :timesheets, :date, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :timesheets, :date_sa, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :timesheets, :date_vb, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :timesheets, :date_ve, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :timesheets, :date_eb, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :timesheets, :date_ee, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )

    change_table_comment( :timesheets, 'Табель' )

    change_column_comment( :timesheets, :id, 'Унікальний ідентифікатор' )
    change_column_comment( :timesheets, :branch_id, 'Установа' )
    change_column_comment( :timesheets, :institution_id, 'Підрозділ' )
    change_column_comment( :timesheets, :number, 'Номер документа' )
    change_column_comment( :timesheets, :date, 'Дата документа' )
    change_column_comment( :timesheets, :number_sa, 'Номер документа ІС' )
    change_column_comment( :timesheets, :date_sa, 'Дата документа ІС' )
    change_column_comment( :timesheets, :is_del_1c, 'Ознака видалення ІС' )
    change_column_comment( :timesheets, :created_at, 'Дата створення запису' )
    change_column_comment( :timesheets, :updated_at, 'Дата останнього оновлення запису' )

    change_column_comment( :timesheets, :date_vb, 'Дата початку періоду відображення табеля' )
    change_column_comment( :timesheets, :date_ve, 'Дата кінця періоду відображення табеля' )
    change_column_comment( :timesheets, :date_eb, 'Дата початку періоду редагування табеля' )
    change_column_comment( :timesheets, :date_ee, 'Дата кінця періоду редагування табеля' )

    # supplier_orders
    change_column_null( :supplier_orders, :branch_id, false )
    change_column_null( :supplier_orders, :supplier_id, false )

    change_column_default( :supplier_orders, :number, from: nil, to: '' )
    change_column_default( :supplier_orders, :date, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :supplier_orders, :date_start, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    change_column_default( :supplier_orders, :date_end, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )

    change_table_comment( :supplier_orders, 'Замовлення постачальнику' )

    change_column_comment( :supplier_orders, :id, 'Унікальний ідентифікатор' )
    change_column_comment( :supplier_orders, :branch_id, 'Установа' )
    change_column_comment( :supplier_orders, :supplier_id, 'Постачальник' )
    change_column_comment( :supplier_orders, :number, 'Номер документа ІС' )
    change_column_comment( :supplier_orders, :date, 'Дата документа ІС' )
    change_column_comment( :supplier_orders, :is_del_1c, 'Ознака видалення ІС' )
    change_column_comment( :supplier_orders, :created_at, 'Дата створення запису' )
    change_column_comment( :supplier_orders, :updated_at, 'Дата останнього оновлення запису' )

    change_column_comment( :supplier_orders, :date_start, 'Дата початку періоду замовлення' )
    change_column_comment( :supplier_orders, :date_end, 'Дата кінця періоду замовлення' )
  end
end
