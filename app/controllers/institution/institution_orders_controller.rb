class Institution::InstitutionOrdersController < Institution::BaseController

  def index
  end

  def ajax_filter_institution_orders # Фильтрация таблицы заявок
    if params[ :date_start ] && params[ :date_start ]
      date_start = params[ :date_start ] ? params[ :date_start ] : params[ :date_end ]
      date_end = params[ :date_end ] ? params[ :date_end ] : params[ :date_start ]
      @institution_orders = InstitutionOrder.where( institution: current_institution )
                              .where( date_start: date_start..date_end ).or(
        InstitutionOrder.where( date_end: date_start..date_end )).order( :date_start )
    end
  end

  def ajax_filter_io_corrections # Фильтрация корректировок заявки
    @io_corrections = IoCorrection.where( institution_order_id: params[ :id ] ).order( :number ) if params[ :id ]
  end

  def delete # Удаление
    InstitutionOrder.find_by( id: params[ :id ] ).destroy if params[ :id ]
  end

  def products # Отображение товаров
    @institution_order = InstitutionOrder.find_by( id: params[ :id ] )
    @institution_order_products = @institution_order.institution_order_products.order( :date )
  end

  # Веб-сервис загрузки графика
  def create
    date_start = params[ :date_start ].to_date
    date_end = params[ :date_end ].to_date

    message = { 'GetRequest' => { 'ins0:StartDate' => date_start,
                                  'ins0:EndDate' => date_end,
                                  'ins0:DepartmentsCode' => current_institution.code } }
    response = Savon.client( wsdl: $ghSavon[ :wsdl ], namespaces: $ghSavon[ :namespaces ] )
                 .call( :get_schedule_of_food_supply, message: message )
    interface_state = response.body[ :get_schedule_of_food_supply_response ][ :return ][ :interface_state ]
    respond = response.body[ :get_schedule_of_food_supply_response ][ :return ][ :food ]

    if interface_state == 'OK'
      InstitutionOrder.transaction do
        institution_order = InstitutionOrder.create( institution: current_institution,
                                                     date_start: date_start, date_end: date_end )
        if respond
          respond.each do | f |
            product = product_code( f[ :code_of_food ].strip )
            institution_order.institution_order_products.create( product: product, date: f[ :date ],
              description: f[ :comments ], count: 0 ) unless product[ :error ]
          end
        end

        redirect_to institution_institution_orders_products_path( id: institution_order.id )
      end
    end
  end

  def update # Обновление реквизитов документа заявки
    update = params.permit( :date ).to_h
    InstitutionOrder.where( id: params[ :id ] ).update_all( update ) if params[ :id ] && update.any?
  end

  def product_update # Обновление количества
    update = params.permit( :count ).to_h
    InstitutionOrderProduct.where( id: params[ :id ] ).update_all( update ) if params[ :id ] && update.any?
  end

  def send_sa # Веб-сервис отправки
    institution_order = InstitutionOrder.find_by( id: params[ :id ] )
    institution_order_products = institution_order.institution_order_products.where.not( count: 0 )
    if institution_order_products
      message = { 'CreateRequest' => { 'ins0:Institutions_id' => institution_order.institution.code,
                                       'ins0:DateStart' => institution_order.date_start.strftime( '%Y-%m-%d' ),
                                       'ins0:DateFinish' => institution_order.date_end.strftime( '%Y-%m-%d' ),
                                       'ins0:NumberFromWebPortal' => institution_order.number,
                                       'ins0:TMC' => institution_order_products.map{ | o | {
                                         'ins0:Product_id' => o.product.code,
                                         'ins0:Date' => o.date,
                                         'ins0:Count_po' => o.count.to_s } } } }
      response = Savon.client( wsdl: $ghSavon[ :wsdl ], namespaces: $ghSavon[ :namespaces ] ).
        call( :creation_application_units, message: message )
      interface_state = response.body[ :creation_application_units_response ][ :return ][ :interface_state ]
      number = response.body[ :creation_application_units_response ][ :return ][ :respond ]

      if interface_state == 'OK'
        institution_order.update( date_sa: Date.today, number_sa: number )
        redirect_to institution_institution_orders_index_path
      else
       render json: { interface_state: interface_state, message: message }
      end
    else
      render text: 'Количество не проставлено'
    end
  end

  # Создания корректировки заявки
  def correction_create
    institution_order = InstitutionOrder.find_by( id: params[ :id ] )

    message = { 'GetRequest' => { 'ins0:StartDate' => institution_order.date_start,
                                  'ins0:EndDate' => institution_order.date_end,
                                  'ins0:DepartmentsCode' => current_institution.code } }
    response = Savon.client( wsdl: $ghSavon[ :wsdl ], namespaces: $ghSavon[ :namespaces ] )
                 .call( :get_schedule_of_food_supply, message: message )

    interface_state = response.body[ :get_schedule_of_food_supply_response ][ :return ][ :interface_state ]
    respond = response.body[ :get_schedule_of_food_supply_response ][ :return ][ :food ]

    if interface_state == 'OK'
      IoCorrection.transaction do
        io_correction = IoCorrection.create( institution_order: institution_order )

        if respond
          respond.each do |f|
            product = product_code( f[ :code_of_food ].strip )
            io_correction.io_correction_products.create( product: product, date: f[ :date ],
                                                         description: f[ :comments ] ) unless product[ :error ]
          end
        end

        redirect_to institution_institution_orders_correction_products_path( id: io_correction.id )
      end
    end
  end

  def correction_delete # Удаление корректировки заявки
    IoCorrection.find_by( id: params[ :id ] ).destroy if params[ :id ]
  end

  def correction_products # Отображение товаров корректировки заявки
    @io_correction = IoCorrection.find_by( id: params[ :id ] )
    @institution_order = @io_correction.institution_order

    select_column = [ 'COALESCE(institution_order_products.count, 0) as count' ]
    joins_table = " LEFT OUTER JOIN institution_order_products
                      ON institution_order_products.product_id = io_correction_products.product_id
                        AND institution_order_products.date = io_correction_products.date
                        AND institution_order_products.institution_order_id = #{ @institution_order.id } "

    @io_correction_products = @io_correction.io_correction_products.select( select_column )
                                .joins( joins_table ).order( :date, 'products.name' )
  end

  def correction_update # Обновление реквизитов документа корректировки
    update = params.permit( :date ).to_h
    IoCorrection.where( id: params[ :id ] ).update_all( update ) if params[ :id ] && update.any?
  end

  def correction_product_update # Обновление количества корректировки заявки
    update = params.permit( :diff ).to_h
    IoCorrectionProduct.where( id: params[ :id ] ).update_all( update ) if params[ :id ] && update.any?
  end

  def correction_send_sa # Веб-сервис отправки корректировки
    io_correction = IoCorrection.find_by( id: params[ :id ] )
    institution_order = io_correction.institution_order
    io_correction_products = io_correction.io_correction_products.where.not( diff: 0 )
    if io_correction_products
      message = { 'CreateRequest' => { 'ins0:Institutions_id' => institution_order.institution.code,
                                       'ins0:NumberFromWebPortal' => io_correction.number,
                                       'ins0:ApplicationNumber' => institution_order.number,
                                       'ins0:TMC' => io_correction_products.map{ | o | {
                                         'ins0:Product_id' => o.product.code,
                                         'ins0:Date' => o.date,
                                         'ins0:Count_po' => o.diff.to_s } } } }
      response = Savon.client( wsdl: $ghSavon[ :wsdl ], namespaces: $ghSavon[ :namespaces ] )
                      .call( :creation_correction_application_units, message: message )
      interface_state = response.body[ :creation_correction_application_units_response ][ :return ][ :interface_state ]
      number = response.body[ :creation_correction_application_units_response ][ :return ][ :respond ]

      if interface_state == 'OK'
        io_correction.update( date_sa: Date.today, number_sa: number )
        redirect_to institution_institution_orders_index_path
      else
        render json: { interface_state: interface_state, message: message }
      end
    else
      render text: 'Количество не проставлено'
    end
  end

end
