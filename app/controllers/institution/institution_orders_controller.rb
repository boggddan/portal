class Institution::InstitutionOrdersController < Institution::BaseController
  def index
  end

  def get_schedule_of_food_supply( date_start, date_end ) # Веб-сервис на заявку
    message = { 'GetRequest' => { 'StartDate' => date_start,
                                  'EndDate' => date_end,
                                  'DepartmentsCode' => current_institution.code } }
    method_name = :get_schedule_of_food_supply
    response = Savon.client( SAVON )
                 .call( method_name, message: message )
                 .body[ "#{ method_name }_response".to_sym ][ :return ]

    web_service = { call: { savon: SAVON, method: method_name.to_s.camelize, message: message } }

    { response: response, web_service: web_service }
  end

  def ajax_filter_institution_orders # Фильтрация таблицы заявок
    date_start = params[ :date_start ]
    date_end = params[ :date_end ]

    @institution_orders =
      InstitutionOrder.where( institution: current_institution ).where( date_start: date_start..date_end )
      .or(InstitutionOrder.where( institution: current_institution ).where( date_end: date_start..date_end ) )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
  end

  def create # Создание заявки
    date_start = params[ :date_start ].to_date
    date_end = params[ :date_end ].to_date

    get_schedule = get_schedule_of_food_supply( date_start, date_end )
    response = get_schedule[ :response ]
    web_service = get_schedule[ :web_service ]

    result = { }
    foods = response[ :food ]

    if response[ :interface_state ] == 'OK' && foods
      ActiveRecord::Base.transaction do
        institution_order = InstitutionOrder.create( institution: current_institution,
                                                     date_start: date_start, date_end: date_end )
        foods.each do | food |
          product = product_code( food[ :code_of_food ] )

          if product[ :error ]
            result = { status: false, caption: 'Неможливо створити документ',
                       message: { error: product[ :error ] }.merge!( web_service ) }
            raise ActiveRecord::Rollback
          else
            institution_order.institution_order_products
              .create( product: product, date: food[ :date ], description: food[ :comments ] )

            #SuppliersPackage.select( :package_id )
            #  .where( product: product, institution: current_institution ).group( :package_id ) do
          end
        end
        result = { status: true, urlParams: { id: institution_order.id } }
      end
    else
      result = { status: false, caption: 'За вибраний період даних немає в 1С',
                 message: web_service.merge!( response: response ) }
    end

    render json: result
  end

  def delete # Удаление
    InstitutionOrder.find( params[ :id ] ).destroy
    render json: { status: true }
  end

  def ajax_filter_corrections # Фильтрация корректировок заявки
    @institution_order = InstitutionOrder.find( params[ :institution_order_id ] )
    @io_corrections = @institution_order.io_corrections.order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
  end

  def correction_create # Создание корректировки заявки
    institution_order = InstitutionOrder.find( params[ :institution_order_id ] )

    get_schedule = get_schedule_of_food_supply( institution_order.date_start,
                                                institution_order.date_end )
    response = get_schedule[ :response ]
    web_service = get_schedule[ :web_service ]

    result = { }

    foods = response[ :food ]

    if response[ :interface_state ] == 'OK' && foods
      ActiveRecord::Base.transaction do
        ioc_last_id = institution_order.io_corrections.last.try( :id )
        io_correction = IoCorrection.create( institution_order: institution_order )

        foods.each do | food |
          product = product_code( food[ :code_of_food ] )

          if product[ :error ]
            result = { status: false, caption: 'Неможливо створити документ',
                       message: { error: product[ :error ] }.merge!( web_service ) }
            raise ActiveRecord::Rollback
          else
            date = food[ :date ]

            where = { product: product, date: date }

            amount_order = ( ioc_last_id ?
              IoCorrectionProduct.select( :amount ).find_by( where.merge(io_correction_id: ioc_last_id ) ).try( :amount )
              : institution_order.institution_order_products.select( :amount ).find_by( where ).try( :amount )
            ) || 0

            io_correction.io_correction_products
              .create( product: product, date: date, description: food[ :comments ], amount_order: amount_order, amount: amount_order  )
          end
        end
        result = { status: true, urlParams: { id: io_correction.id } }
      end
    else
      result = { status: false, caption: 'За вибраний період даних немає в 1С',
                 message: web_service.merge!( response: response ) }
    end

    render json: result
  end

  def correction_delete # Удаление корректировки заявки
    IoCorrection.find( params[ :id ] ).destroy
    render json: { status: true }
  end

  def products # Отображение товаров
    @institution_order = InstitutionOrder.find( params[ :id ] )
    @institution_order_products = @institution_order.institution_order_products
      .select( :id, :product_id, :date, :amount, :description )
      .joins( product: [ :products_type ] )
      .select( 'products.name AS name', 'products_types.name AS type' )
      .order( :date, 'products_types.priority','products.name' )
  end

  def update # Обновление реквизитов документа заявки
    update = params.permit( :date ).to_h
    InstitutionOrder.find( params[ :id ] ).update( update ) if params[ :id ] && update.any?
    render json: { status: true }
  end

  def product_update # Обновление количества
    update = params.permit( :amount ).to_h
    InstitutionOrderProduct.find( params[ :id ] ).update( update ) if params[ :id ] && update.any?
    render json: { status: true }
  end

  def send_sa # Веб-сервис отправки
    institution_order = InstitutionOrder.find( params[ :id ] )
    institution_order_products = institution_order.institution_order_products.where.not( amount: 0 )

    result = { }
    if institution_order_products.present?
      message = { 'CreateRequest' => { 'Institutions_id' => current_institution.code,
                                       'DateStart' => institution_order.date_start,
                                       'DateFinish' => institution_order.date_end,
                                       'NumberFromWebPortal' => institution_order.number,
                                       'TMC' => institution_order_products.map{ | o | {
                                         'Product_id' => o.product.code,
                                         'Date' => o.date,
                                         'Count_po' => o.amount.to_s } },
                                       'User' => current_user.username } }
      method_name = :creation_application_units
      response = Savon.client( SAVON ).call( method_name, message: message )
                   .body[ "#{ method_name }_response".to_sym ][ :return ]

      web_service = { call: { savon: SAVON, method: method_name.to_s.camelize, message: message } }

      if response[ :interface_state ] == 'OK'
        institution_order.update( date_sa: Date.today, number_sa: response[ :respond ] )
        institution_order.institution_order_products.where( amount: 0 ).destroy_all
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

  def print # Веб-сервис отправки
    institution_order = InstitutionOrder.find( params[ :id ] )

    result = { }
    message = { 'CreateRequest' => { 'Date' => institution_order.date_sa,
                                     'NumberFromWebPortal' => institution_order.number } }
    method_name = :get_print_form_of_order_of_devision

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

  def correction_products # Отображение товаров корректировки заявки
    @io_correction = IoCorrection.find( params[ :id ] )
    @institutin_order = @io_correction.institution_order
    @io_correction_products = @io_correction.io_correction_products
                                    .select( :id, :product_id, :date, :amount_order, :amount, :description )
                                    .joins( product: [ :products_type ] )
                                    .select( 'products.name AS name', 'products_types.name AS type' )
                                    .order( :date, 'products_types.priority','products.name' )
  end

  def correction_update # Обновление реквизитов документа корректировки
    update = params.permit( :date ).to_h
    IoCorrection.find( params[ :id ] ).update( update ) if params[ :id ] && update.any?
    render json: { status: true }
  end

  def correction_product_update # Обновление количества корректировки заявки
    update = params.permit( :amount ).to_h
    IoCorrectionProduct.find( params[ :id ] ).update( update ) if params[ :id ] && update.any?
    render json: { status: true }
  end

  def correction_send_sa # Веб-сервис отправки
    io_correction = IoCorrection.find( params[ :id ] )
    institution_order = io_correction.institution_order
    io_correction_products = io_correction.io_correction_products.where.not( amount: 0 )

    result = { }
    if io_correction_products.present?
      institution_order = io_correction.institution_order
      message = { 'CreateRequest' => { 'Institutions_id' => current_institution.code,
                                       'NumberFromWebPortal' => io_correction.number,
                                       'ApplicationNumber' => institution_order.number,
                                       'TMC' => io_correction_products.map{ | o | {
                                         'Product_id' => o.product.code,
                                         'Date' => o.date,
                                         'Count_po' => (o.amount - o.amount_order).to_s } },
                                       'User' => current_user.username } }
      method_name = :creation_correction_application_units
      response = Savon.client( SAVON )
                   .call( method_name, message: message )
                   .body[ "#{ method_name }_response".to_sym ][ :return ]

      web_service = { call: { savon: SAVON, method: method_name.to_s.camelize, message: message } }

      if response[ :interface_state ] == 'OK'
        io_correction.update( date_sa: Date.today, number_sa: response[ :respond ] )
        io_correction.io_correction_products.where( amount: 0 ).destroy_all

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

end
