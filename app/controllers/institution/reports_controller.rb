class Institution::ReportsController < Institution::BaseController

  def ajax_report_base
   method_name = params[ :method_name ]
   is_pdf = params[ :is_pdf ]
   message = { 'CreateRequest' => { 'Institutions_id' => current_institution.code,
                                    'StartDate' => params[ :date_start ].to_date,
                                    'EndDate' => params[ :date_end ].to_date }
                                  .merge!( is_pdf.blank? ? {} : { 'IsPDF' => is_pdf } )
   }

   response = Savon.client( SAVON ).call( method_name.to_sym, message: message )
                     .body[ "#{ method_name }_response".to_sym ][ :return ]

   web_service = { call: { savon: SAVON, method: method_name.camelize, message: message } }

   render json: response[ :interface_state ] == 'OK' ?
      { status: true, ( is_pdf && is_pdf == 'true' ? :href : :view ) => respond = response[ :respond ] }
      : { status: false, caption: 'Неуспішна сихронізація з 1С', message: web_service.merge!( response: response ) }
  end

  # Вартість дітодня за меню-вимогами
  def children_day_cost
    @main_params = { h1_text: 'Звіт "Вартість дітодня за меню-вимогами"', is_pdf: false,
      path_view: institution_reports_ajax_report_base_path( method_name: :get_report_the_cost_of_the_child_day_according_to_the_menu_requirements ) }
    render 'report_base'
  end

  # Залишки продуктів харчування
  def balances_in_warehouses
    @main_params = { h1_text: 'Звіт "Залишки продуктів харчування"', is_pdf: true,
      path_view: institution_reports_ajax_report_base_path( method_name: :get_report_statement_on_balances_in_warehouses ) }

    render 'report_base', h1_text: 'Звіт "Залишки продуктів харчування"'
  end

  # Табель обліку відвідування дітей
  def attendance_of_children
    @children_groups = current_institution.children_groups.order( :code )
  end

  def ajax_attendance_of_children
    is_pdf = params[ :is_pdf ]

    message = { 'CreateRequest' => { 'StartDate' => params[ :date_start ].to_date,
                                     'EndDate' => params[ :date_end ].to_date,
                                     'Institutions_id' => current_institution.code,
                                     'Children_group_id' => params[ :children_group_code ] || '',
                                     'IsPDF' => is_pdf } }

    method_name = :get_report_the_record_of_attendance_of_children
    response = Savon.client( SAVON ).call( method_name, message: message )
                     .body[ "#{ method_name }_response".to_sym ][ :return ]

    web_service = { call: { savon: SAVON, method: method_name.to_s.camelize, message: message } }

    render json: response[ :interface_state ] == 'OK' ?
      { status: true, ( is_pdf=='true' ? :href : :view ) => respond = response[ :respond ] }
      : { status: false, caption: 'Неуспішна сихронізація з 1С', message: web_service.merge!( response: response ) }
  end

end
