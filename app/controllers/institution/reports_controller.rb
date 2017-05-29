class Institution::ReportsController < Institution::BaseController

  def index
  end

  # Вартість дітодня за меню-вимогами
  def children_day_cost
    @h1_text = 'Звіт "Вартість дітодня за меню-вимогами"'
    @path_view = institution_reports_ajax_children_day_cost_path
    render 'report_base'
  end

  def ajax_children_day_cost
    message = { 'CreateRequest' => { 'Institutions_id' => current_institution.code,
                                     'StartDate' => params[ :date_start ].to_date,
                                     'EndDate' => params[ :date_end ].to_date } }
    response = Savon.client( SAVON )
                 .call( :get_report_the_cost_of_the_child_day_according_to_the_menu_requirements, message: message )

    body = response.body[ :get_report_the_cost_of_the_child_day_according_to_the_menu_requirements_response ][ :return ]

    if body[ :interface_state ] == 'OK'
      respond = body[ :respond ]
      @result = respond.html_safe
    else
      @result = 'За вибраний період данних немає'
    end
  end

  # Залишки продуктів харчування
  def balances_in_warehouses
    @h1_text = 'Звіт "Залишки продуктів харчування"'
    @path_view = institution_reports_ajax_balances_in_warehouses_path
    render 'report_base'
  end

  def ajax_balances_in_warehouses
    message = { 'CreateRequest' => { 'ins0:Institutions_id' => current_institution.code,
                                     'ins0:StartDate' => params[ :date_start ].to_date,
                                     'ins0:EndDate' => params[ :date_end ].to_date } }
    response = Savon.client( SAVON )
                 .call( :get_report_statement_on_balances_in_warehouses, message: message )

    body = response.body[ :get_report_statement_on_balances_in_warehouses_response ][ :return ]

    if body[ :interface_state ] == 'OK'
      respond = body[ :respond ]
      @result = respond.html_safe
    else
      @result = 'За вибраний період данних немає'
    end
  end

  # Табель обліку відвідування дітей
  def attendance_of_children
    @children_groups = current_institution.children_groups.order( :code )
  end

  def ajax_attendance_of_children
    message = { 'CreateRequest' => { 'StartDate' => params[ :date_start ].to_date,
                                     'EndDate' => params[ :date_end ].to_date,
                                     'Institutions_id' => current_institution.code,
                                     'Children_group_id' => params[ :children_group_code ] } }

    response = Savon.client( wsdl: $ghSavon[ :wsdl ], namespaces: $ghSavon[ :namespaces ] )
                 .call( :get_report_the_record_of_attendance_of_children, message: message )

    body = response.body[ :get_report_the_record_of_attendance_of_children_response ][ :return ]

    if body[ :interface_state ] == 'OK'
      respond = body[ :respond ]
      @result = respond.html_safe
    else
      @result = 'За вибраний період данних немає'
    end
  end

end
