class Institution::ReportsController < Institution::BaseController

  def index
  end

  def children_day_cost
  end


  # Веб-сервис загрузки графика
  def ajax_children_day_cost_create
    message = { 'CreateRequest' => { 'ins0:Institutions_id' => current_institution.code,
                                     'ins0:StartDate' => params[ :date_start ].to_date,
                                     'ins0:EndDate' => params[ :date_end ].to_date } }
    response = Savon.client( wsdl: $ghSavon[ :wsdl ], namespaces: $ghSavon[ :namespaces ] )
                 .call( :get_report_the_cost_of_the_child_day_according_to_the_menu_requirements, message: message )

    body = response.body[ :get_report_the_cost_of_the_child_day_according_to_the_menu_requirements_response ][ :return ]

    if body[ :interface_state ] == 'OK'
      respond = body[ :respond ]
      @result = respond.html_safe
      puts @result

    else
      @result = 'За вибраний період данних немає'
    end

  end

end
