class Institution::ReceiptsController < Institution::BaseController

  def index
  end

  def ajax_filter_supplier_orders # Фильтрация заявок поставщикам
    if params[ :date_start ] && params[ :date_end ]
      date_start = params[ :date_start ] ? params[ :date_start ] : params[ :date_end ]
      date_end = params[:date_end] ? params[ :date_end ] : params[ :date_start ]
      @supplier_orders = SupplierOrder.where( branch: current_branch, date: date_start..date_end )
        .where( ( { supplier_id: params[ :supplier_id ] } if params[ :supplier_id ] && !params[ :supplier_id ].blank? ) )
        .order( :date )
    end
  end

  def ajax_filter_contract_numbers # Фильтрация списка договоров
    if params[ :id ]
      @supplier_order = SupplierOrder.find_by( id: params[ :id ] )
      @contracts = @supplier_order.supplier_order_products.select( :contract_number )
                     .distinct( :contract_number ).where( institution: current_institution )
    end
  end

  def ajax_filter_receipts # Фильтрация документов поставок
    if params[ :id ]
      @receipts = Receipt.where( supplier_order_id: params[ :id ])
        .where( ( { contract_number: ( params[ :contract_number ] )
          } if params[ :contract_number ] && !params[ :contract_number ].blank? ) )
        .order( :date )
    end
  end

  def ajax_suppliers_autocomplete_source # Источник для автозаполнение для фильтрации поставщиков
    render json: Supplier.select( 'name AS label', 'id as value' )
                   .where( 'lower(name) LIKE ?', "%#{ params[ :term.downcase ] }%")
                   .order( :name ).limit( 15 ).as_json( only: [ :label, :value ] )
  end

  def send_sa # Веб-сервис отправки поступления
    receipt = Receipt.find_by( id: params[ :id ] )
    receipt_products = receipt.receipt_products.where.not( count: 0 )

    if receipt_products.present?
      message = { 'GetRequest' => { 'ins0:Institutions_id' => receipt.institution.code,
                                    'ins0:InvoiceNumber' => receipt.invoice_number,
                                    'ins0:ContractNumber' => receipt.contract_number,
                                    'ins0:OrderNumber' => receipt.supplier_order.number,
                                    'ins0:NumberFromWebPortal' => receipt.number,
                                    'ins0:Date' => receipt.date,
                                    'ins0:Goods' => receipt_products.map{ | o | {
                                      'ins0:CodeOfGoods' => o.product.code,
                                      'ins0:Quantity' => o.count.to_s,
                                      'ins0:Count_invoice' => o.count_invoice.to_s,
                                      'ins0:Cause_deviation_code' => o.causes_deviation.code } } } }
      response = Savon.client( wsdl: $ghSavon[ :wsdl ], namespaces:  $ghSavon[ :namespaces ] )
                   .call( :create_doc_supply_goods, message: message )

      return_value = response.body[ :create_doc_supply_goods_response ][ :return ]

      if return_value[ :interface_state ] && return_value[ :interface_state ] == 'OK'
        receipt.update( date_sa: Date.today, number_sa: return_value[ :respond ] )
        redirect_to institution_receipts_index_path
      else
        logger.info "interface_state: [#{ return_value[ :interface_state ] }], message: [#{ message }]"
      end
    else
      render text: 'Количество не проставлено'
    end
  end

  def create # создание поступления
    supplier_order = SupplierOrder.find_by( id: params[ :id ] )
    if supplier_order
      Receipt.transaction do
        receipt = Receipt.create( institution: current_institution, supplier_order: supplier_order,
                                  contract_number: params[ :contract_number ] )
        supplier_order.supplier_order_products.where( institution: current_institution, contract_number: params[ :contract_number ] )
          .order( :date ).each do |sop|
            ReceiptProduct.create( receipt: receipt, date: sop.date, product_id: sop.product_id, count: sop.count )
        end

        redirect_to institution_receipts_products_path( id: receipt.id )
      end
    end
  end

  def ajax_select_supplier_order # Выбор заявки: - Фильтрация списка выбора с договорами
    @contracts = SupplierOrderProduct.select( :contract_number ).distinct( :contract_number ).
          where( institution: current_institution,
            supplier_order_id: params[ :supplier_order_id ].present? ? params[ :supplier_order_id ]
              : ( @supplier_order.present? ? @supplier_order.id : 0 )  )
  end

  def delete # Удаление поступления
    Receipt.find_by( id: params[ :id ] ).destroy if params[ :id ]
  end

  def products # Отображение товаров поступления
    @receipt = Receipt.find_by( id: params[ :id ] )
    @receipt_products = @receipt.receipt_products.order( :date )
  end

  def product_update # Обновление количества
    update = params.permit( :count ).to_h
    ReceiptProduct.where( id: params[ :id ] ).update_all( update ) if params[ :id ] && update.any?
  end

  def update # Обновление реквизитов документа поступления
    update = params.permit( :date, :invoice_number ).to_h
    Receipt.where( id: params[ :id ] ).update_all( update ) if params[ :id ] && update.any?
  end
end