class Institution::ReceiptsController < Institution::BaseController

  def index ; end

  def ajax_filter_supplier_orders # Фильтрация заявок поставщикам
    @supplier_orders =  JSON.parse( SupplierOrder
      .joins( :supplier )
      .select( :id,
               :number,
               :date,
               :date_start,
               :date_end,
               :is_del_1c,
               'suppliers.name AS name' )
      .where( branch_id: current_institution[ :branch_id ],
              date: params[ :date_start ]..params[ :date_end ] )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
      .to_json, symbolize_names: true )
  end

  def ajax_filter_contracts # Фильтрация списка договоров
    @supplier_order = SupplierOrder.find( params[ :supplier_order_id ] )
    @contracts = @supplier_order.supplier_order_products
      .select( "( CASE WHEN contract_number_manual = '' THEN contract_number ELSE contract_number_manual END ) AS contract_number" )
      .distinct( :contract_number )
      .where( institution_id: current_user[ :userable_id ] )
  end

  def ajax_filter_receipts # Фильтрация документов поставок
    contract_number = params[ :contract_number ]
    where = contract_number.present? ? { contract_number_manual: contract_number }: ''
    @receipts = JSON.parse( Receipt
      .select( :id,
               :number,
               :number_sa,
               :date_sa,
               :contract_number,
               :invoice_number,
               :is_del_1c )
      .where( institution_id: current_user[ :userable_id ],
              supplier_order_id: params[ :supplier_order_id ] )
      .where( where )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
      .to_json, symbolize_names: true )
  end

  def send_sa # Веб-сервис отправки поступления
    receipt_id = params[ :id ]
    receipt = JSON.parse( Receipt
      .joins( :supplier_order, :institution )
      .select( :id,
               :invoice_number,
               :number,
               :date,
               :contract_number,
               :institution_id,
               'supplier_orders.number AS so_number',
               'supplier_orders.date AS so_date',
               'supplier_orders.date_start AS so_date_start',
               'supplier_orders.date_end AS so_date_end',
               'institutions.code AS institution_code' )
      .find( receipt_id )
      .to_json, symbolize_names: true )


    so_date_start = receipt[ :so_date_start ].to_date
    so_date_end = receipt[ :so_date_end ].to_date

    date = receipt[ :date ].to_date
    institution_id = receipt[ :institution_id ]

    if date.between?( so_date_start, so_date_end )

      date_blocks = check_date_block( institution_id, date )
      if date_blocks.present?
        caption = 'Блокування документів'
        message = "Дата поставки [ #{ date_blocks } ] закрита для відправлення!"
        result = { status: false, message: message, caption: caption }
      else
        receipt_products = JSON.parse( ReceiptProduct
          .joins( :causes_deviation, :product )
          .select( :id, :count, :count_invoice, :date, :product_id,
                  'causes_deviations.code AS deviation_code',
                  'products.code AS product_code')
          .where( receipt_id: receipt_id )
          .where.not( count: 0 )
          .or( ReceiptProduct
              .joins( :causes_deviation, :product )
              .select(:id, :count, :count_invoice, :date, :product_id,
                  'causes_deviations.code AS deviation_code',
                  'products.code AS product_code')
              .where( receipt_id: receipt_id )
              .where.not( count_invoice: 0 )
          )
          .to_json, symbolize_names: true )

        result = { }

        if receipt_products.present?
          goods = receipt_products.map{ | o | {
            'CodeOfGoods' => o[ :product_code ],
            'Quantity' => o[ :count ],
            'Count_invoice' => o[ :count_invoice ],
            'Cause_deviation_code' => o[ :deviation_code ]
            }
          }

          message = {
            'GetRequest' => {
              'Institutions_id' => receipt[ :institution_code ],
              'InvoiceNumber' => receipt[ :invoice_number ],
              'ContractNumber' => receipt[ :contract_number ],
              'OrderNumber' => receipt[ :so_number ],
              'NumberFromWebPortal' => receipt[ :number ],
              'Date' => receipt[ :date ],
              'DateOfOrderNumber' => receipt[ :so_date ],
              'Goods' => goods,
              'User' => current_user[ :username ]
            }
          }

          savon_return = get_savon( :create_doc_supply_goods, message )
          response = savon_return[ :response ]
          web_service = savon_return[ :web_service ]

          if response[ :interface_state ] == 'OK'
            ActiveRecord::Base.transaction do
              data = { date_sa: Date.today, number_sa: response[ :respond ].to_s }
              update_base_with_id( :receipts, receipt_id, data )

              ReceiptProduct
                .where( receipt_id: receipt_id, count: 0, count_invoice: 0 )
                .delete_all
            end
            result = { status: true }
          else
            result = { status: false, caption: 'Неуспішна сихронізація з ІС',
                      message: web_service.merge!( response: response ) }
          end
        else
          result = { status: false, caption: 'Кількість не проставлена' }
        end
      end
    else
      result = { status: false,
                 caption: "Період Замовлення постачальника #{ so_date_start.strftime( '%d.%m.%Y' ) }" +
                 " - #{ date_end.strftime( '%d.%m.%Y' ) } відрізняється від дати в поставці " +
                 "#{ date.strftime( '%d.%m.%Y' ) }" }
    end

    render json: result
  end

  def create # создание поступления
    supplier_order_id = params[ :supplier_order_id ]
    contract_number_manual = params[ :contract_number ]
    institution_id = current_user[ :userable_id ]

    sop = SupplierOrderProduct
      .select( :contract_number )
      .find_by( supplier_order_id: supplier_order_id,
                contract_number_manual: contract_number_manual )

    contract_number = sop ? sop.contract_number : contract_number_manual

    result = { }

    ActiveRecord::Base.transaction do
      data = { institution_id: institution_id,
               supplier_order_id: supplier_order_id,
               contract_number_manual: contract_number_manual,
               contract_number: contract_number }
      id = insert_base_single( 'receipts', data )

      causes_deviation_id = CausesDeviation.select( :id ).find_by( code:  '' ).id

      fields = %w( receipt_id causes_deviation_id date product_id count_order price ).join( ',' )
      sql = <<-SQL.squish
          INSERT INTO receipt_products (#{ fields})
            SELECT #{ id },
                   #{ causes_deviation_id },
                   date,
                   product_id,
                   count,
                   price
            FROM supplier_order_products
            WHERE supplier_order_id = #{ supplier_order_id } AND
                  institution_id = #{ institution_id } AND
                  contract_number = '#{ contract_number }'
        SQL

      ActiveRecord::Base.connection.execute( sql )

      href = institution_receipts_products_path( { id: id } )
      result = { status: true, href: href }
    end

    render json: result
  end

  def delete # Удаление поступления
    Receipt.find( params[ :id ] ).destroy
    render json: { status: true }
  end

  def products # Отображение товаров поступления
    @receipt = JSON.parse( Receipt
      .joins( supplier_order: :supplier )
      .select( :id,
               :number_sa,
               :date_sa,
               :number,
               :date,
               :invoice_number,
               :contract_number,
               'supplier_orders.number AS supplier_order_number',
               'suppliers.name AS supplier_name'
      )
      .find( params[ :id ] )
      .to_json, symbolize_names: true )

    @receipt_products = JSON.parse( ReceiptProduct
      .joins( :product )
      .select( :id,
               :product_id,
               :causes_deviation_id,
               :date,
               :price,
               :count_order,
               :count_invoice,
               :count,
               'products.name AS name' )
      .where( receipt_id: @receipt[ :id ] )
      .order( :date,
              'products.name' )
      .to_json, symbolize_names: true )
  end

  def product_update # Обновление количества
    data = params.permit( :count, :count_invoice, :causes_deviation_id ).to_h
    status = update_base_with_id( :receipt_products, params[ :id ], data )
    render json: { status: status }
  end

  def update # Обновление реквизитов документа поступления
    data = params.permit( :date, :invoice_number ).to_h

    result = nil

    if data.present?
      date = data[ :date ]
      id = params[ :id ]

      if date.present?
        institution_id = Receipt.select( :institution_id ).find( id ).institution_id

        date_blocks = check_date_block( institution_id, date )
        if date_blocks.present?
          caption = 'Блокування документів'
          message = "Дата списання #{ date_blocks } закрита для редагування!"
          result = { status: false, message: message, caption: caption }
        else
          Receipt.where( id: id ).update_all( data )
          result = { status: true }
        end
      else
        Receipt.where( id: id ).update_all( data )
        result = { status: true }
      end
    end

    render json: result
  end

  def print # Веб-сервис отправки
    receipt =  JSON.parse( Receipt
      .select( :number, :date_sa )
      .find( params[ :id ] )
      .to_json, symbolize_names: true )

    result = { }
    message = { 'CreateRequest' => { 'Date' => receipt[ :date_sa ],
                                     'NumberFromWebPortal' => receipt[ :number ] } }
    savon_return = get_savon( :get_print_form_of_supply_goods, message )
    response = savon_return[ :response ]
    web_service = savon_return[ :web_service ]

    render json: response[ :interface_state ] == 'OK' ?
      { status: true, href: response[ :respond ] }
      :
      { status: false, caption: 'Неуспішна сихронізація з ІС',
        message: web_service.merge!( response: response ) }
  end

end
