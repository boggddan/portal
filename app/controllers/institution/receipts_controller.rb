class Institution::ReceiptsController < Institution::BaseController

  def index ; end

  def ajax_filter_supplier_orders # Фильтрация заявок поставщикам
    @supplier_orders = SupplierOrder
      .select( :id, :date, :number, :is_del_1c, 'suppliers.name AS name' )
      .joins( :supplier )
      .where( branch_id: current_institution[ :branch_id ],
              date: params[ :date_start ]..params[ :date_end ] )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
  end

  def ajax_filter_contracts # Фильтрация списка договоров
    @supplier_order = SupplierOrder.find( params[ :supplier_order_id ] )
    @contracts = @supplier_order.supplier_order_products
                     .select( :contract_number )
                     .distinct( :contract_number )
                     .where( institution_id: current_user[ :userable_id ] )
  end

  def ajax_filter_receipts # Фильтрация документов поставок
    contract_number = params[ :contract_number ]
    @receipts = Receipt
      .where( institution_id: current_user[ :userable_id ] )
      .where( supplier_order_id: params[ :supplier_order_id ] )
      .where( ( { contract_number: ( contract_number ) } if contract_number && !contract_number.blank? ) )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
  end

  def send_sa # Веб-сервис отправки поступления
    receipt_id = params[ :id ]
    receipt = JSON.parse( Receipt
      .joins( :supplier_order )
      .select( :id, :invoice_number, :number, :date, :contract_number,
               'supplier_orders.number AS so_number' )
      .find( receipt_id )
      .to_json, symbolize_names: true )

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
      goods = receipt_products.map{ | o | { 'CodeOfGoods' => o[ :product_code ],
                                            'Quantity' => o[ :count ],
                                            'Count_invoice' => o[ :count_invoice ],
                                            'Cause_deviation_code' => o[ :deviation_code ] } }

      message = { 'GetRequest' => { 'Institutions_id' => current_institution[ :code ],
                                    'InvoiceNumber' => receipt[ :invoice_number ],
                                    'ContractNumber' => receipt[ :contract_number ],
                                    'OrderNumber' => receipt[ :so_number ],
                                    'NumberFromWebPortal' => receipt[ :number ],
                                    'Date' => receipt[ :date ],
                                    'Goods' => goods,
                                    'User' => current_user[ :username ] } }

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

    render json: result
  end

  def create # создание поступления
    supplier_order_id = params[ :supplier_order_id ]
    contract_number = params[ :contract_number ]
    institution_id = current_user[ :userable_id ]

    result = { }

    ActiveRecord::Base.transaction do
      data = { institution_id: institution_id,
               supplier_order_id: supplier_order_id,
               contract_number: contract_number }
      id = insert_base_single( 'receipts', data )

      causes_deviation_id = CausesDeviation.select( :id ).find_by( code:  '' ).id

      fields = %w( receipt_id causes_deviation_id date product_id count_order price ).join( ',' )
      sql = "INSERT INTO receipt_products (#{ fields}) " +
              "SELECT #{ id },"+
                     "#{ causes_deviation_id }," +
                     "date," +
                     "product_id," +
                     "count," +
                     "price " +
            "FROM supplier_order_products " +
            "WHERE supplier_order_id = #{ supplier_order_id } AND " +
	                "institution_id = #{ institution_id } AND " +
	                "contract_number = '#{ contract_number }'"
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
    @receipt = Receipt.find( params[ :id ] )
    @receipt_products = @receipt.receipt_products
      .select( :id, :product_id, :causes_deviation_id, :date,
               :price, :count_order, :count_invoice, :count,
               'products.name AS name' )
      .joins( :product )
      .order( :date, 'products.name' )
  end

  def product_update # Обновление количества
    data = params.permit( :count, :count_invoice, :causes_deviation_id ).to_h
    status = update_base_with_id( :receipt_products, params[ :id ], data )
    render json: { status: status }
  end

  def update # Обновление реквизитов документа поступления
    data = params.permit( :date, :invoice_number ).to_h
    status = update_base_with_id( :receipts, params[ :id ], data )
    render json: { status: status }
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
