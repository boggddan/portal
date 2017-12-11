class Institution::ReportsController < Institution::BaseController

  def ajax_report_base
    is_pdf = params[ :is_pdf ]
    message = { 'CreateRequest' => { 'Institutions_id' => current_institution[ :code ],
                                    'StartDate' => params[ :date_start ].to_date,
                                    'EndDate' => params[ :date_end ].to_date }
                                  .merge!( is_pdf.nil? ? { } : { 'IsPDF' => is_pdf.to_s } )
    }

    savon_return = get_savon( params[ :method_name ].to_sym, message )
    response = savon_return[ :response ]
    web_service = savon_return[ :web_service ]

    render json: response[ :interface_state ] == 'OK' ?
      { status: true, ( is_pdf && is_pdf == true ? :href : :view ) => respond = response[ :respond ] }
      :
      { status: false, caption: 'Неуспішна сихронізація з ІС',
        message: web_service.merge!( response: response ) }
  end

  # Вартість дітодня за меню-вимогами
  def children_day_cost
    @main_params = { h1_text: 'Звіт "Вартість дітодня за меню-вимогами"', is_pdf: false,
      path_view: institution_reports_ajax_report_base_path( method_name: :get_report_the_cost_of_the_child_day_according_to_the_menu_requirements ) }
    render 'report_base'
  end

  #
  def cost_baby_day
    @main_params = { h1_text: 'Звіт "Вартість дітодня за меню-вимогами"', is_pdf: false,
      path_view: institution_reports_ajax_cost_baby_day_path }
    render 'report_base'
  end

  def ajax_cost_baby_day
    message = {
      'CreateRequest' => {
        'Branch_id' => current_branch[ :code ],
        'Institutions_id' => current_institution[ :code ],
        'StartDate' => params[ :date_start ].to_date,
        'EndDate' => params[ :date_end ].to_date
      }
    }
    savon_return = get_savon( :get_report_cost_baby_day, message )
    response = savon_return[ :response ]
    web_service = savon_return[ :web_service ]

    render json: response[ :interface_state ] == 'OK' ?
      { status: true, view: response[ :respond ] }
      :
      { status: false, caption: 'Неуспішна сихронізація з ІС',
        message: web_service.merge!( response: response ) }
  end

  # Залишки продуктів харчування
  def balances_in_warehouses
    render 'balances_in_warehouses'
  end

  # Залишки продуктів харчування
  def ajax_balances_in_warehouses
    is_pdf = params[ :is_pdf ]

    message = {
      'CreateRequest' => {
        'Institutions_id' => current_institution[ :code ],
        'StartDate' => params[ :date_start ].to_date,
        'EndDate' => params[ :date_end ].to_date,
        'IsPDF' => params[ :is_pdf ].to_s,
        'ShowTheAmount' => params[ :show_amount ].to_s,
        'ShowThePeriod' => params[ :show_period ].to_s
      }
    }

    savon_return = get_savon( :get_report_statement_on_balances_in_warehouses, message )
    response = savon_return[ :response ]
    web_service = savon_return[ :web_service ]

    render json: response[ :interface_state ] == 'OK' ?
      { status: true, ( is_pdf == true ? :href : :view ) => response[ :respond ] }
      :
      { status: false, caption: 'Неуспішна сихронізація з ІС',
        message: web_service.merge!( response: response ) }
  end


  # Табель обліку відвідування дітей
  def attendance_of_children
    @children_groups = ChildrenGroup
      .where( institution_id: current_user[ :userable_id ] )
      .order( :code )
  end

  def ajax_attendance_of_children
    is_pdf = params[ :is_pdf ]

    message = {
      'CreateRequest' => {
        'StartDate' => params[ :date_start ].to_date,
        'EndDate' => params[ :date_end ].to_date,
        'Institutions_id' => current_institution[ :code ],
        'Children_group_id' => params[ :children_group_code ] || '',
        'IsPDF' => is_pdf.to_s
      }
    }

    savon_return = get_savon( :get_report_the_record_of_attendance_of_children, message )
    response = savon_return[ :response ]
    web_service = savon_return[ :web_service ]

    render json: response[ :interface_state ] == 'OK' ?
      { status: true, ( is_pdf == true ? :href : :view ) => response[ :respond ] }
      :
      { status: false, caption: 'Неуспішна сихронізація з ІС',
        message: web_service.merge!( response: response ) }
  end

  # Табель обліку відвідування дітей
  def payment_of_parents

  end

  def ajax_payment_of_parents
    is_pdf = params[ :is_pdf ]
    type_search = params[ :type_search ]
    code_search = params[ :code_search ] || nil

    personal_account = type_search == 'personal_account' ? code_search : code_search
    child_name = type_search == 'child_name' ? code_search : nil

    message = {
      'CreateRequest' => {
        'StartDate' => params[ :date_start ].to_date,
        'EndDate' => params[ :date_end ].to_date,
        'Branch_id' => current_branch[ :code ],
        'Institutions_id' => current_institution[ :code ],
        'PersonalAccount' => personal_account,
        'ChildName' => child_name,
        'TypeOfInstitution' => nil,
        'Advance' => 'true',
        'IsPDF' => is_pdf.to_s
      }
    }

    savon_return = get_savon( :get_report_the_consolidated_statement_for_payment, message )
    response = savon_return[ :response ]
    web_service = savon_return[ :web_service ]

    render json: response[ :interface_state ] == 'OK' ?
      { status: true, ( is_pdf == true ? :href : :view ) => response[ :respond ] }
      :
      { status: false, caption: 'Неуспішна сихронізація з ІС',
        message: web_service.merge!( response: response ) }
  end


end
