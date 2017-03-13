class Institution::TimesheetsController < Institution::BaseController

  def index
  end

  def new
    @timesheet = Timesheet.new( date: Date.today, date_eb: Date.today.beginning_of_month, date_ee: Date.today.end_of_month )
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
            date: ts[ :date ]) unless child[ :error ] && children_group[ :error ] && reasons_absence[ :error ]
        end

        redirect_to institution_timesheets_dates_path( id: timesheet.id )
      end
    end
  end

  def send_sa
    @timesheet = InstitutionOrder.find_by( id: params[ :id ] )
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
        redirect_to institution_orders_index_path
      else
        render json: { interface_state: interface_state, message: message }
      end
    else
      render text: 'Количество не проставлено'
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

    select_column = [ 'MAX(children_categories.name) AS category_name', 'MAX(children_groups.name) AS group_name',
                      'MAX(children.name) AS child_name' ]

    ( @timesheet.date_vb..@timesheet.date_ve ).each_with_index do | value, index |
      select_column << "MAX(CASE date WHEN '#{value}' THEN timesheet_dates.id || '_' || reasons_absences.id || '_' ||
                        reasons_absences.mark ELSE '' END) AS d_#{index+1}"
    end

    @timesheet_dates = @timesheet.timesheet_dates.select( select_column ).
      joins( :children_category, :child, :reasons_absence ).group( 'children_categories.code', 'children_groups.code', 'children.code' )

    #render json: @timesheet_dates

    @date_range = { start: @timesheet.date_ve.day, end: @timesheet.date_vb.day, count: (@timesheet.date_ve.day - @timesheet.date_vb.day + 1) }

    puts "dsdsd #{ @date_range }"

  end

  def update # Обновление реквизитов документа
    update = params.permit( :date ).to_h
    Timesheet.where( id: params[ :id ] ).update_all( update ) if params[ :id ] && update.any?
  end




end
