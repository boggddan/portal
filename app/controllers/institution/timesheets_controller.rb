class Institution::TimesheetsController < Institution::BaseController

  def index
  end

  def new
    @timesheet = Timesheet.new( date: Date.today, date_eb: Date.today.beginning_of_month,
                                date_ee: Date.today.end_of_month )
    render :dates
  end

  # Веб-сервис загрузки графика
  def create
    date_ee = params[ :date_ee ].to_date
    date_eb = params[ :date_eb ].to_date

    message = { 'CreateRequest' => { 'ins0:StartDate' => date_ee,
                                     'ins0:EndDate' => date_eb,
                                     'ins0:Institutions_id' => current_institution.code } }
    response = Savon.client( wsdl: $ghSavon[ :wsdl ], namespaces: $ghSavon[ :namespaces ] )
                 .call( :get_data_time_sheet, message: message )

    interface_state = response.body[ :get_data_time_sheet_response ][ :return ][ :interface_state ]
    return_value = response.body[ :get_data_time_sheet_response ][ :return ]

    if interface_state == 'OK'
      Timesheet.transaction do
        timesheet = Timesheet.create( institution: current_institution, branch: current_branch,
          date_vb: return_value[ :date_vb ], date_ve: return_value[ :date_ve ],
          date_eb: return_value[ :date_eb ], date_ee: return_value[ :date_ee ], date: params[ :date ].to_date )

        return_value[ :ts ].each do | ts |
          child = child_code( ts[ :child_code ].strip )
          children_group = children_group_code( ts[ :children_group_code ].strip )
          reasons_absence = reasons_absence_code(  ( ts[ :reasons_absence_code ] || '' ).strip )

          timesheet.timesheet_dates.create( child: child, children_group: children_group, reasons_absence: reasons_absence,
            date: ts[ :date ]) unless child[ :error ] || children_group[ :error ] || reasons_absence[ :error ]
        end

        redirect_to institution_timesheets_dates_path( id: timesheet.id )
      end
    end
  end

  def send_sa
    timesheet = Timesheet.find_by( id: params[ :id ] )
    timesheet_dates = timesheet.timesheet_dates_join

    if timesheet_dates
      message = { 'CreateRequest' => { 'ins0:Institutions_id' => timesheet.institution.code,
                                       'ins0:NumberFromWebPortal' => timesheet.number,
                                       'ins0:StartDate' => timesheet.date_vb,
                                       'ins0:EndDate' => timesheet.date_ve,
                                       'ins0:StartDateOfTheFill' => timesheet.date_eb,
                                       'ins0:EndDateOfTheFill' => timesheet.date_ee,
                                       'ins0:TS' => timesheet_dates.map{ | o | {
                                         'ins0:Child_code' => o.child_code,
                                         'ins0:Children_group_code' => o.children_group_code,
                                         'ins0:Reasons_absence_code' => o.reasons_absence_code,
                                         'ins0:Date' => o.date  } } } }

      response = Savon.client( wsdl: $ghSavon[ :wsdl ], namespaces: $ghSavon[ :namespaces ] )
        .call( :creation_time_sheet, message: message )
      interface_state = response.body[ :creation_time_sheet_response ][ :return ][ :interface_state ]
      number = response.body[ :creation_time_sheet_response ][ :return ][ :respond ]

      if interface_state == 'OK'
        timesheet.update( date_sa: Date.today, number_sa: number )
        redirect_to institution_timesheets_index_path
      else
        render json: { interface_state: interface_state, message: message }
      end
    else
      render text: 'Пустая таблица не проставлено'
    end
  end

  def ajax_filter_timesheets # Фильтрация документов
    if params[ :date_start ] && params[ :date_start ]
      date_start = params[ :date_start ] ? params[ :date_start ] : params[ :date_end ]
      date_end = params[ :date_end ] ? params[ :date_end ] : params[ :date_start ]
      @timesheets = Timesheet.where( institution: current_institution, date: date_start..date_end ).order( :date )
    end
  end

  def delete # Удаление документа
    Timesheet.find_by( id: params[ :id ] ).destroy if params[ :id ]
  end

  def dates # Отображение дней табеля
    @timesheet = Timesheet.find_by( id: params[ :id ] )

    @group_timesheet =[]
    children_category_id = 0

    @timesheet.timesheet_dates
      .select( 'DISTINCT ON (children_groups.children_category_id, timesheet_dates.children_group_id)
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

    @reasons_absences = ReasonsAbsence.select( :id, :code, :mark ).where( code: '' ).or(
      ReasonsAbsence.select( :id, :code, :mark ).where.not( mark: '' ) ).order( :priority ).pluck( :id, :code, :mark )
  end

  def update # Обновление реквизитов документа
    update = params.permit( :date ).to_h
    Timesheet.where( id: params[ :id ] ).update_all( update ) if params[ :id ] && update.any?
  end

  def dates_update # Обновление маркера
    update = params.permit( :reasons_absence_id ).to_h
    TimesheetDate.where( id: params[ :id ] ).update_all( update ) if params[ :id ] && update.any?
  end

  def ajax_filter_timesheet_dates # Фильтрация таблицы
    if params[ :id ]
      @timesheet = Timesheet.find_by( id: params[ :id ] )

      if params[ :field ] == 'children_group_id'
        where = { children_group_id: params[ :field_id ] }
      elsif params[ :field ] == 'children_category_id'
        where = "children_groups.children_category_id = #{ params[ :field_id ] }"
      else
        where = ''
      end

      @timesheet_dates = @timesheet.timesheet_dates_join.where( where )
    end
  end
end
