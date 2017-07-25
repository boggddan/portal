class Institution::TimesheetsController < Institution::BaseController

  def index ; end

  def new ; end

  def ajax_filter_timesheets # Фильтрация документов
    @timesheets = Timesheet
      .where( institution: current_institution, date: params[ :date_start ]..params[ :date_end ] )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
  end

  def delete # Удаление документа
    id = params[ :id ]
    if id
      sql = "DELETE FROM timesheet_dates WHERE timesheet_id = #{ id };" +
            "DELETE FROM timesheets WHERE id = #{ id }"
      ActiveRecord::Base.connection.execute( sql )
    end

    render json: { status: true }
  end

  def create
    date_start = params[ :date_start ].to_date
    date_end = params[ :date_end ].to_date

    timesheet_exists = current_institution.timesheets.select( :id, :number, :date, :date_eb, :date_ee )
                           .where( date_eb: date_start..date_end )
      .or( current_institution.timesheets.select( :id, :number, :date, :date_eb, :date_ee ).where( date_ee: date_start..date_end ) )
      .order( :number )

    if timesheet_exists.present?
      result = { status: false, caption: 'За выбраний період уже створений табель',
                 message: timesheet_exists.map{ |v| {
                     id: v[:id], 'Номер': v[ :number ], 'Дата:': date_str( v[ :date ]),
                     'З': date_str( v[ :date_eb ] ), 'ПО': date_str( v[ :date_ee ] ) } }  }
    else
      message = { 'CreateRequest' => { 'StartDate' => date_start,
                                        'EndDate' => date_end,
                                        'Institutions_id' => current_institution.code } }
      method_name = :get_data_time_sheet
      response = Savon.client( SAVON )
                    .call( method_name, message: message )
                    .body[ "#{ method_name }_response".to_sym ][ :return ]

      web_service = { call: { savon: SAVON, method: method_name.to_s.camelize, message: message } }

      ts_data = response[ :ts ]

      result = { }
      if response[ :interface_state ] == 'OK' && ts_data && ts_data.present?
        error = { }

        children_codes = ts_data.group_by { | o | o[ :child_code ] }.map { | k, v | k }
        children = exists_codes( :children, children_codes )
        error.merge!( children[ :error ] ) unless children[ :status ]

        children_groups_codes = ts_data.group_by { | o | o[ :children_group_code ] }.map { | k, v | k }
        children_groups = exists_codes( :children_groups, children_groups_codes )
        error.merge!( children_groups[ :error ] ) unless children_groups[ :status ]

        reasons_absences_code = ts_data.group_by { | o | o[ :reasons_absence_code ] }.map { | k, v | k }
        reasons_absences = exists_codes( :reasons_absences, reasons_absences_code )
        error.merge!( reasons_absences[ :error ] ) unless reasons_absences[ :status ]

        if error.empty?
          ActiveRecord::Base.transaction do
            now = Time.now.to_s( :db )

            timesheet = Timesheet.create( institution: current_institution,
                                          branch: current_branch,
                                          date_vb: response[ :date_vb ],
                                          date_ve: response[ :date_ve ],
                                          date_eb: response[ :date_eb ],
                                          date_ee: response[ :date_ee ],
                                          date: now )
            id = timesheet.id

            fields = %w( timesheet_id children_group_id child_id reasons_absence_id
                        date created_at updated_at ).join( ',' )

            sql_values = ''

            ts_data.each { | ts |
              sql_values += ",(#{ id }," +
                            "#{ children_groups[ :obj ][ ts[ :children_group_code ] || '' ] }," +
                            "#{ children[ :obj ][ ts[ :child_code ] || '' ] }," +
                            "#{ reasons_absences[ :obj ][ ts[ :reasons_absence_code ] || '' ] }," +
                            "'#{ ts[ :date ] }'," +
                            "'#{ now }','#{ now }')"
            }

            sql = "INSERT INTO timesheet_dates ( #{ fields } ) VALUES #{ sql_values[1..-1] }"

            ActiveRecord::Base.connection.execute( sql )

            href = institution_timesheets_dates_path( { id: id } )
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
    end

    render json: result
  end

  def send_sa
    timesheet = Timesheet.find( params[ :id ] )

    timesheet_dates = timesheet.timesheet_dates
      .select( :id, :date, 'children_categories.code AS category_code',
        'children_groups.code AS group_code', 'children.code AS child_code',
        'reasons_absences.code AS reason_code' )
      .joins( :children_category, :children_group, :child, :reasons_absence )
      .order( 'category_code', 'group_code', 'child_code', :date )

    result = { }
    if timesheet_dates.present?
      message = { 'CreateRequest' => { 'Institutions_id' => current_institution.code,
                                       'NumberFromWebPortal' => timesheet.number,
                                       'StartDate' => timesheet.date_vb,
                                       'EndDate' => timesheet.date_ve,
                                       'StartDateOfTheFill' => timesheet.date_eb,
                                       'EndDateOfTheFill' => timesheet.date_ee,
                                       'TS' => timesheet_dates.map{ | o | {
                                         'Child_code' => o.child_code,
                                         'Children_group_code' => o.group_code,
                                         'Reasons_absence_code' => o.reason_code,
                                         'Date' => o.date  } },
                                       'User' => current_user.username } }
      method_name = :creation_time_sheet
      response = Savon.client( SAVON ).call( method_name, message: message )
                   .body[ "#{ method_name }_response".to_sym ][ :return ]

      web_service = { call: { savon: SAVON, method: method_name.to_s.camelize, message: message } }

      if response[ :interface_state ] == 'OK'
        timesheet.update( date_sa: Date.today, number_sa: response[ :respond ] )
        result = { status: true }
      else
        result = { status: false, caption: 'Неуспішна сихронізація з 1С',
                   message: web_service.merge!( response: response ) }
      end
    else
      result = { status: false, caption: 'Немає данних' }
    end

    render json: result
  end

  def dates # Отображение дней табеля
    @timesheet = Timesheet.find_by( id: params[ :id ] )

    reasons_absences = JSON.parse( ReasonsAbsence.select( :id, :code, :mark ).where( code: '' )
      .or( ReasonsAbsence.select( :id, :code, :mark ).where.not( mark: '' ) )
      .order( :priority )
      .to_json, symbolize_names: true )

    @reasons_absences = [ ]
    reasons_absences.zip( reasons_absences.rotate ) { | item, item_next |
      @reasons_absences << item.merge( { next_id: item_next[:id], next_mark: item_next[ :mark ] } ) }

    @group_timesheet = []
    children_category_id = 0

    @timesheet.timesheet_dates
      .select( 'DISTINCT ON ( children_groups.children_category_id, timesheet_dates.children_group_id )
        children_groups.children_category_id', :children_group_id,
        'children_categories.name AS category_name', 'children_groups.name AS group_name' )
      .joins( :children_category, :children_group )
      .each do | o |
        if children_category_id != o.children_category_id
          children_category_id = o.children_category_id
          @group_timesheet << [ o.category_name, o.children_category_id,
            { class: :row_group, data: { field: :children_category_id } } ]
        end

        @group_timesheet << [ o.group_name, o.children_group_id, { data: { field: :children_group_id } } ]
      end
  end

  def update # Обновление реквизитов документа
    update = params.permit( :id, :date ).to_h
    Timesheet.where( id: params[ :id ] ).update_all( update ) if params[ :id ] && update.any?
    render json: { status: true }
  end

  def dates_update # Обновление маркера
    update = params.permit( :reasons_absence_id ).to_h
    TimesheetDate.find( params[ :id ] ).update( update ) if params[ :id ] && update.any?
    render json: { status: true }
  end

  def dates_updates # Обновление группы маркеров
    update = params.permit( { ids: [] }, :reasons_absence_id ).to_h
    reasons_absence_id = update[ :reasons_absence_id ]

    ActiveRecord::Base.transaction do
      update[ :ids ].each do | id |
        TimesheetDate.find( id ).update( reasons_absence_id: reasons_absence_id )
      end
    end

    render json: { status: true }
  end

  def ajax_filter_timesheet_dates # Фильтрация таблицы
    @timesheet = Timesheet.find( params[ :id ] )
    field = params[ :field ]

    where = ''
    where = "#{ field == 'children_group_id' ? field : 'children_groups.children_category_id' }
      = #{ params[ :field_id ] }" if ['children_group_id', 'children_category_id'].include?(field)

    @timesheet_dates = @timesheet.timesheet_dates
      .select( :id, :timesheet_id, 'children_groups.children_category_id', :children_group_id, :child_id,
               :reasons_absence_id, :date,
               'children_categories.name AS category_name', 'children_groups.name AS group_name',
               'children.name AS child_name', 'reasons_absences.mark AS mark',
               'children_categories.code AS category_code', 'children_groups.code AS group_code',
               'children.code AS child_code', 'reasons_absences.code AS reason_code' )
      .joins( :children_category, :children_group, :child, :reasons_absence )
      .order( 'category_name', 'group_name', 'child_name', :date )
      .where( where )
  end
end
