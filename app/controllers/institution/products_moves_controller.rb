class Institution::ProductsMovesController < Institution::BaseController

  def index ; end

  def filter # Фильтрация документов
    institution_id = current_user[ :userable_id ]
    where = <<-SQL.squish
        ( institution_id = #{ institution_id } OR to_institution_id = #{ institution_id } )
      SQL

    @products_moves = JSON.parse( ProductsMove
      .joins( :to_institution )
      .select( :id,
               :number,
               :date,
               :number_sa,
               :date_sa,
               :is_confirmed,
               :is_del_1c,
               "CASE WHEN institution_id = #{ institution_id } THEN 0 ELSE 1 END AS tip",
               "CASE WHEN institution_id = #{ institution_id } THEN 'Видача' ELSE 'Прийом' END AS tip_name",
               'institutions.name AS institution_name' )
      .where( date: params[ :date_start ]..params[ :date_end ] )
      .where( where )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
      .to_json, symbolize_names: true )
  end

  def delete # Удаление документа
    ProductsMove.find( params[ :id ] ).destroy
    render json: { status: true }
  end

  def create
    institution_id = current_user[ :userable_id ]

    sql = <<-SQL.squish
        WITH new_products_moves( id ) AS (
          INSERT INTO products_moves ( institution_id )
            VALUES ( #{ institution_id } )
            RETURNING id
            )
          INSERT INTO products_move_products
            ( products_move_id, product_id )
            SELECT new_products_moves.id,
                    products.id
              FROM new_products_moves, products
            RETURNING products_move_id
      SQL

    products_move_id = JSON.parse( ActiveRecord::Base.connection.execute( sql )
      .to_json, symbolize_names: true )[ 0 ][ :products_move_id ]

    href = institution_products_moves_products_path( { id: products_move_id } )
    result = { status: true, href: href }

    render json: result
  end

  def send_sa
    # timesheet_id = params[ :id ]

    # timesheet = JSON.parse( Timesheet
    #   .select( :id,
    #             :number,
    #             :date_vb,
    #             :date_ve,
    #             :date_eb,
    #             :date_ee )
    #   .find( timesheet_id )
    #   .to_json, symbolize_names: true )

    # date_start = timesheet[ :date_eb ]
    # date_end = timesheet[ :date_ee ]

    # date_blocks = check_date_block( date_start, date_end )
    # if date_blocks.present?
    #   caption = 'Блокування документів'
    #   message = "Дата [ #{ date_blocks } ] в табелі закрита для відправлення!"
    #   result = { status: false, message: message, caption: caption }
    # else
    #   timesheet_dates = JSON.parse( TimesheetDate
    #     .joins( { children_group: :children_category }, :child, :reasons_absence )
    #     .select( :id, :date,
    #             'children_categories.code AS category_code',
    #             'children_groups.code AS group_code',
    #             'children.code AS child_code',
    #             'reasons_absences.code AS reason_code' )
    #     .where( timesheet_id: timesheet_id )
    #     .order( 'category_code', 'group_code', 'child_code', :date )
    #     .to_json, symbolize_names: true )

    #   result = { }
    #   if timesheet_dates.present?
    #     ts = timesheet_dates.map{ | o | {
    #       'Child_code' => o[ :child_code ],
    #       'Children_group_code' => o[ :group_code ],
    #       'Reasons_absence_code' => o[ :reason_code ],
    #       'Date' => o[ :date ]
    #       }
    #     }

    #     message = {
    #       'CreateRequest' => {
    #         'Institutions_id' => current_institution[ :code ],
    #         'NumberFromWebPortal' => timesheet[ :number ],
    #         'StartDate' => timesheet[ :date_vb ],
    #         'EndDate' => timesheet[ :date_ve ],
    #         'StartDateOfTheFill' => date_start,
    #         'EndDateOfTheFill' => date_end,
    #         'TS' => ts,
    #         'User' => current_user[ :username ]
    #      }
    #     }

    #     savon_return = get_savon( :creation_time_sheet, message )
    #     response = savon_return[ :response ]
    #     web_service = savon_return[ :web_service ]

    #     if response[ :interface_state ] == 'OK'
    #       data = { date_sa: Date.today, number_sa: response[ :respond ].to_s }
    #       update_base_with_id( :timesheets, timesheet_id, data )
    #       result = { status: true }
    #     else
    #       result = { status: false, caption: 'Неуспішна сихронізація з ІС',
    #                 message: web_service.merge!( response: response ) }
    #     end
    #   else
    #     result = { status: false, caption: 'Немає данних' }
    #   end
    # end

    # render json: result
  end

  def products #
    institution_id = current_user[ :userable_id ]

    @products_move = JSON.parse( ProductsMove
      .select( :id,
               :number,
               :date,
               :number_sa,
               :date_sa,
               :institution_id,
               :to_institution_id,
               "CASE WHEN institution_id = #{ institution_id } THEN 0 ELSE 1 END AS tip" )
      .find( params[ :id ] )
      .to_json, symbolize_names: true )

      @products_move_products = JSON.parse( ProductsMoveProduct
        .joins( { product: :products_type } )
        .select( :product_id,
                :amount,
                'products.products_type_id',
                'products_types.name AS products_type_name',
                'products.name AS product_name' )
        .where( products_move_id: @products_move[ :id ] )
        .order( 'products_types.priority',
                'products_types.name',
                'products.name' )
        .to_json, symbolize_names: true )

        @institutions = Institution
          .select(:id, :name )
          .where( branch_id: current_institution[ :branch_id ] )
          .order( :name )
          .pluck( :name, :id )
  end

  def update # Обновление реквизитов документа
    data = params.permit( :date, :to_institution_id ).to_h
    status = update_base_with_id( :products_moves, params[ :id ], data )
    render json: { status: status }
  end

  def dates_update # Обновление маркера
    data = params.permit( :reasons_absence_id ).to_h
    status = update_base_with_id( :timesheet_dates, params[ :id ], data )
    render json: { status: status }
  end

  def dates_updates # Обновление группы маркеров
    data = params.permit( { ids: [] }, :reasons_absence_id ).to_h
    reasons_absence_id = data[ :reasons_absence_id ]

    if data.present?
      sql = "UPDATE timesheet_dates SET " +
              "reasons_absence_id = #{ reasons_absence_id } " +
            "FROM UNNEST(ARRAY" +
              "#{ data[ :ids ].map { | o | o.to_i }.to_s }" +
            ") as ids " +
            "WHERE id = ids "

      ActiveRecord::Base.connection.execute( sql )
    end

    render json: { status: true }
  end

  def ajax_filter_timesheet_dates # Фильтрация таблицы
    id = params[ :id ]
    @timesheet = Timesheet.find( id )
    field = params[ :field ]

    where = ''
    where = "#{ field == 'children_group_id' ? field : 'children_groups.children_category_id' }
      = #{ params[ :field_id ] }" if ['children_group_id', 'children_category_id'].include?(field)

    @timesheet_dates = JSON.parse( TimesheetDate
      .select( :id, :timesheet_id, 'children_groups.children_category_id', :children_group_id, :child_id,
               :reasons_absence_id, :date,
               'children_categories.name AS category_name', 'children_groups.name AS group_name',
               'children.name AS child_name', 'reasons_absences.mark AS mark',
               'children_categories.code AS category_code', 'children_groups.code AS group_code',
               'children.code AS child_code', 'reasons_absences.code AS reason_code' )
      .joins( { children_group: :children_category }, :child, :reasons_absence )
      .order( 'category_name', 'group_name', 'child_name', :date )
      .where( timesheet_id: id )
      .where( where )
      .to_json, symbolize_names: true )
  end
end

