class Institution::InstitutionOrdersController < Institution::BaseController
  def index ; end

  def get_schedule_of_food_supply( date_start, date_end ) # Веб-сервис на заявку
    message = { 'GetRequest' => { 'StartDate' => date_start,
                                  'EndDate' => date_end,
                                  'DepartmentsCode' => current_institution[ :code ] } }

    get_savon( :get_schedule_of_food_supply, message )
  end

  def ajax_filter_institution_orders # Фильтрация таблицы заявок
    date_start = params[ :date_start ]
    date_end = params[ :date_end ]
    institution_id = current_user[ :userable_id ]

    @institution_orders =
      InstitutionOrder
        .where( institution_id: institution_id,
                date_start: date_start..date_end )
      .or( InstitutionOrder
        .where( institution_id: current_user[ :userable_id ],
                date_end: date_start..date_end ) )
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

    if response[ :interface_state ] == 'OK' && foods && foods.present?
      error = { }

      products_codes = foods.group_by { | o | o[ :code_of_food ] }.map { | k, v | k }
      products = exists_codes( :products, products_codes )
      error.merge!( products[ :error ] ) unless products[ :status ]

      if error.empty?
        ActiveRecord::Base.transaction do
          data = { institution_id: current_user[ :userable_id ],
                   date_start: date_start,
                   date_end: date_end }

          id = InstitutionOrder.create( data ).id

          fields = %w( institution_order_id product_id date description ).join( ',' )

          sql_values = ''

          foods.each { | food |
            product_id = products[ :obj ][ ( food[ :code_of_food ] || '' ).strip ]
            sql_values += ",(#{ id }," +
                          "#{ product_id }," +
                          "'#{ food[ :date ] }'," +
                          "'#{ food[ :description ] }')"
          }

          sql = "INSERT INTO institution_order_products ( #{ fields } ) VALUES #{ sql_values[1..-1] }"

          ActiveRecord::Base.connection.execute( sql )

          href = institution_institution_orders_products_path( { id: id } )
          result = { status: true, href: href }
        end
      else
        result = { status: false, caption: 'Неможливо створити документ',
                   message: { error: error }.merge!( web_service ) }
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
    @io_corrections = @institution_order.io_corrections
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
  end

  def correction_create # Создание корректировки заявки
    institution_order_id = params[ :institution_order_id ]

    institution_order = JSON.parse( InstitutionOrder
      .select( :id, :date_start, :date_end )
      .find( institution_order_id )
      .to_json, symbolize_names: true )

    get_schedule = get_schedule_of_food_supply( institution_order[ :date_start ],
                                                institution_order[ :date_end ] )
    response = get_schedule[ :response ]
    web_service = get_schedule[ :web_service ]

    result = { }
    foods = response[ :food ]

    if response[ :interface_state ] == 'OK' && foods && foods.present?
      error = { }

      products_codes = foods.group_by { | o | o[ :code_of_food ] }.map { | k, v | k }
      products = exists_codes( :products, products_codes )
      error.merge!( products[ :error ] ) unless products[ :status ]

      if error.empty?
        ioc_last_id = IoCorrection
          .select( :id )
          .where( institution_order_id: institution_order_id )
          .last
          .try( :id )

        amounts = JSON.parse( ( ioc_last_id ?
          IoCorrectionProduct
            .select( :product_id, :date, :amount )
            .where( io_correction_id: ioc_last_id )
          :
          InstitutionOrderProduct
            .select( :product_id, :date, :amount )
            .where( institution_order_id: institution_order_id )
          ).to_json, symbolize_names: true )

        ActiveRecord::Base.transaction do
          data = { institution_order_id: institution_order_id }
          id = IoCorrection.create( data ).id

          fields = %w( io_correction_id product_id date amount_order
                       amount description ).join( ',' )

          sql_values = ''

          foods.each { | food |
            product_id = products[ :obj ][ ( food[ :code_of_food ] || '' ).strip ]
            date =  food[ :date ].to_date.to_s( :db )
            amount = amounts
              .select{ | o | o[ :product_id ] == product_id && o[ :date ] == date }
              .fetch( 0,  { amount: 0 } )[ :amount ]

            sql_values += ",(#{ id }," +
                          "#{ product_id }," +
                          "'#{ date }'," +
                          "#{ amount }," +
                          "#{ amount }," +
                          "'#{ food[ :description ] }')"
          }

          sql = "INSERT INTO io_correction_products ( #{ fields } ) VALUES #{ sql_values[1..-1] }"

          ActiveRecord::Base.connection.execute( sql )

          href = institution_institution_orders_correction_products_path( { id: id } )
          result = { status: true, href: href }
        end
      else
        result = { status: false, caption: 'Неможливо створити документ',
                  message: { error: error }.merge!( web_service ) }
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
    @institution_order_products = @institution_order
      .institution_order_products
        .select( :id, :product_id, :date, :amount, :description )
        .joins( product: [ :products_type ] )
        .select( 'products.name AS name', 'products_types.name AS type' )
        .order( :date, 'products_types.priority','products.name' )
  end

  def update # Обновление реквизитов документа заявки
    data = params.permit( :date ).to_h
    status = update_base_with_id( :institution_orders, params[ :id ], data )
    render json: { status: status }
  end

  def product_update # Обновление количества
    data = params.permit( :amount ).to_h
    status = update_base_with_id( :institution_order_products, params[ :id ], data )
    render json: { status: status }
  end

  def send_sa # Веб-сервис отправки
    institution_order_id = params[ :id ]

    institution_order = JSON.parse( InstitutionOrder
      .select( :id, :number, :date_start, :date_end )
      .find( institution_order_id )
      .to_json, symbolize_names: true )

    institution_order_products = JSON.parse( InstitutionOrderProduct
      .joins( :product )
      .select( 'products.code AS code', :date, :amount )
      .where( institution_order_id: institution_order_id )
      .where.not( amount: 0 )
      .to_json, symbolize_names: true )

    result = { }
    if institution_order_products.present?
      tmc = institution_order_products.map{ | o | { 'Product_id' => o[ :code ],
                                                    'Date' => o[ :date ],
                                                    'Count_po' => o[ :amount ] } }

      message = { 'CreateRequest' => { 'Institutions_id' => current_institution[ :code ],
                                       'DateStart' => institution_order[ :date_start ],
                                       'DateFinish' => institution_order[ :date_end ],
                                       'NumberFromWebPortal' => institution_order[ :number ],
                                       'TMC' => tmc,
                                       'User' => current_user[ :username ] } }
      savon_return = get_savon( :creation_application_units, message )
      response = savon_return[ :response ]
      web_service = savon_return[ :web_service ]

      if response[ :interface_state ] == 'OK'
        ActiveRecord::Base.transaction do
          data = { date_sa: Date.today, number_sa: response[ :respond ].to_s }
          update_base_with_id( :institution_orders, institution_order_id, data )

          InstitutionOrderProduct
            .where( institution_order_id: institution_order_id, amount: 0 )
            .delete_all

          result = { status: true }
        end
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
    institution_order = JSON.parse( InstitutionOrder
      .select( :number, :date_sa )
      .find( params[ :id ] )
      .to_json, symbolize_names: true )

    result = { }
    message = { 'CreateRequest' => { 'Date' => institution_order[ :date_sa ],
                                     'NumberFromWebPortal' => institution_order[ :number ] } }

    savon_return = get_savon( :get_print_form_of_order_of_devision, message )
    response = savon_return[ :response ]
    web_service = savon_return[ :web_service ]

    render json: response[ :interface_state ] == 'OK' ?
      { status: true, href: response[ :respond ] }
      :
      { status: false, caption: 'Неуспішна сихронізація з 1С',
        message: web_service.merge!( response: response ) }
  end

  def correction_products # Отображение товаров корректировки заявки
    @io_correction = IoCorrection
      .joins( :institution_order )
      .select( :id, :number, :date, :number_sa, :date_sa,
               'institution_orders.number AS io_number',
               'institution_orders.date AS io_date' )
      .find( params[ :id ] )

    @io_correction_products = @io_correction
      .io_correction_products
        .select( :id, :product_id, :date, :amount_order, :amount, :description )
        .joins( product: [ :products_type ] )
        .select( 'products.name AS name', 'products_types.name AS type' )
        .order( :date, 'products_types.priority','products.name' )
  end

  def correction_update # Обновление реквизитов документа корректировки
    data = params.permit( :date ).to_h
    status = update_base_with_id( :io_corrections, params[ :id ], data )
    render json: { status: status }
  end

  def correction_product_update # Обновление количества корректировки заявки
    data = params.permit( :amount ).to_h
    status = update_base_with_id( :io_correction_products, params[ :id ], data )
    render json: { status: status }
  end

  def correction_send_sa # Веб-сервис отправки
    io_correction_id = params[ :id ]

    io_correction = JSON.parse( IoCorrection
      .joins( :institution_order )
      .select( :number, 'institution_orders.number AS io_number')
      .find( io_correction_id )
      .to_json, symbolize_names: true )

    io_correction_products = JSON.parse( IoCorrectionProduct
      .joins( :product )
      .select( 'products.code AS code', :date, :amount, :amount_order )
      .where( io_correction_id: io_correction_id )
      .where.not( amount: 0 )
      .to_json( methods: :diff_amount ), symbolize_names: true )
      .delete_if { | o | o[ :diff_amount ] == '0.0' }

    result = { }
    if io_correction_products.present?
      tmc = io_correction_products.map{ | o | { 'Product_id' => o[ :code ],
                                                'Date' => o[ :date ],
                                                'Count_po' => o[ :diff_amount ] } }

      message = { 'CreateRequest' => { 'Institutions_id' => current_institution[ :code ],
                                       'NumberFromWebPortal' => io_correction[ :number ],
                                       'ApplicationNumber' => io_correction[ :io_number ],
                                       'TMC' => tmc,
                                       'User' => current_user[ :username ] } }
      savon_return = get_savon( :creation_correction_application_units, message )
      response = savon_return[ :response ]
      web_service = savon_return[ :web_service ]

      if response[ :interface_state ] == 'OK'
        ActiveRecord::Base.transaction do
          data = { date_sa: Date.today, number_sa: response[ :respond ].to_s }
          update_base_with_id( :io_corrections, params[ :id ], data )

          IoCorrectionProduct
            .where( io_correction_id: io_correction_id, amount: 0 )
            .delete_all

          result = { status: true }
        end
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
