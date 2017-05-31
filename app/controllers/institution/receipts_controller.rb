class Institution::ReceiptsController < Institution::BaseController

  # def ffff # Веб-сервис отправки поступления
  #   puts 'dfdfdfd'
  #   render json: { status: false }
  # end

  def index
  end

  def ajax_filter_supplier_orders # Фильтрация заявок поставщикам
    @supplier_orders = SupplierOrder
      .select( :id, :date, :number, 'suppliers.name AS name' )
      .joins( :supplier )
      .where( branch: current_branch, date: params[ :date_start ]..params[ :date_end ] )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )

    #.where( ( { supplier_id: params[ :supplier_id ] } if params[ :supplier_id ] && !params[ :supplier_id ].blank? ) )
  end

  def ajax_filter_contracts # Фильтрация списка договоров
    @supplier_order = SupplierOrder.find( params[ :supplier_order_id ] )
    @contracts = @supplier_order.supplier_order_products
                     .select( :contract_number )
                     .distinct( :contract_number )
                     .where( institution: current_institution )
  end

  def ajax_filter_receipts # Фильтрация документов поставок
    contract_number = params[ :contract_number ]
    @receipts = Receipt.where( supplier_order_id: params[ :supplier_order_id ])
      .where( ( { contract_number: ( contract_number ) } if contract_number && !contract_number.blank? ) )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
  end

  # def ajax_suppliers_autocomplete_source # Источник для автозаполнение для фильтрации поставщиков
  #   render json: Supplier.select( 'name AS label', 'id as value' )
  #                  .where( 'lower(name) LIKE ?', "%#{ params[ :term.downcase ] }%")
  #                  .order( :name ).limit( 15 ).as_json( only: [ :label, :value ] )
  # end

  def send_sa # Веб-сервис отправки поступления
    receipt = Receipt.find( params[ :id ] )
    receipt_products = receipt.receipt_products.where.not( count: 0 )
    result = { }
    if receipt_products.present?
      message = { 'GetRequest' => { 'Institutions_id' => receipt.institution.code,
                                    'InvoiceNumber' => receipt.invoice_number,
                                    'ContractNumber' => receipt.contract_number,
                                    'OrderNumber' => receipt.supplier_order.number,
                                    'NumberFromWebPortal' => receipt.number,
                                    'Date' => receipt.date,
                                    'Goods' => receipt_products.map{ | o | {
                                      'CodeOfGoods' => o.product.code,
                                      'Quantity' => o.count.to_s,
                                      'Count_invoice' => o.count_invoice.to_s,
                                      'Cause_deviation_code' => o.causes_deviation.code } },
                                    'User' => current_user.username } }

      method_name = :create_doc_supply_goods
      response = Savon.client( SAVON ).call( method_name, message: message )
                     .body[ "#{ method_name }_response".to_sym ][ :return ]

      web_service = { call: { savon: SAVON, method: method_name.to_s.camelize, message: message } }

      if response[ :interface_state ] == 'OK'
        receipt.update( date_sa: Date.today, number_sa: response[ :respond ] )
        receipt.receipt_products.where.not( count: 0 ).destroy_all
        result = { status: true }
      else
        result = { status: false, caption: 'Неуспішна сихронізація з 1С',
                   message: web_service.merge!( response: response ) }
      end
    else
      result = { status: false, caption: 'Кількість не проставлена' }
    end

    render json: result
  end



  def create # создание поступления
    contract_number = params[ :contract_number ]
    supplier_order = SupplierOrder.find( params[ :supplier_order_id ] )
    result = { }

    ActiveRecord::Base.transaction do
      receipt = Receipt.create( institution: current_institution, supplier_order: supplier_order,
                                  contract_number: contract_number  )

      causes_deviation = causes_deviation_code( '' )
      supplier_order.supplier_order_products.where( institution: current_institution, contract_number: contract_number )
        .order( :date )
        .each{ |sop| ReceiptProduct.create(receipt: receipt, date: sop.date, product_id: sop.product_id,
               count_order: sop.count, causes_deviation: causes_deviation, price: sop.price ) }
      result = { status: true, urlParams: { id: receipt.id } }
    end
    render json: result
  end

  # def ajax_select_supplier_order # Выбор заявки: - Фильтрация списка выбора с договорами
  #   @contracts = SupplierOrderProduct.select( :contract_number ).distinct( :contract_number ).
  #         where( institution: current_institution,
  #           supplier_order_id: params[ :supplier_order_id ].present? ? params[ :supplier_order_id ]
  #             : ( @supplier_order.present? ? @supplier_order.id : 0 )  )
  # end

  def delete # Удаление поступления
    Receipt.find( params[ :id ] ).destroy
    render json: { status: true }
  end

  def products # Отображение товаров поступления
    @receipt = Receipt.find( params[ :id ] )
    @receipt_products = @receipt.receipt_products
      .select( :id, :product_id, :causes_deviation_id, :date, :count_order, :count_invoice, :count, 'products.name AS name' )
      .joins( :product )
      .order( :date, 'products.name' )
  end

  def product_update # Обновление количества
    update = params.permit( :count, :count_invoice, :causes_deviation_id ).to_h
    ReceiptProduct.find( params[ :id ] ).update( update ) if params[ :id ] && update.any?
    render json: { status: true }
  end

  def update # Обновление реквизитов документа поступления
    update = params.permit( :date, :invoice_number ).to_h
    Receipt.find( params[ :id ] ).update( update ) if params[ :id ] && update.any?
    render json: { status: true }
  end

  def print # Веб-сервис отправки
    receipt = Receipt.find( params[ :id ] )

    result = { }
    message = { 'CreateRequest' => { 'Date' => receipt.date_sa,
                                     'NumberFromWebPortal' => receipt.number } }
    method_name = :get_print_form_of_supply_goods

    response = Savon.client( SAVON ).call( method_name, message: message )
                   .body[ "#{ method_name }_response".to_sym ][ :return ]

    web_service = { call: { savon: SAVON, method: method_name.to_s.camelize, message: message } }

    if response[ :interface_state ] == 'OK'
      result = { status: true, href: response[ :respond ] }
    else
      result = { status: false, caption: 'Неуспішна сихронізація з 1С',
                 message: web_service.merge!( response: response ) }
    end

    render json: result
  end

end
