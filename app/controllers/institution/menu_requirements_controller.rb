class Institution::MenuRequirementsController < Institution::BaseController

  def index
  end

  def ajax_filter_menu_requirements # Фильтрация документов
    @menu_requirements = MenuRequirement
      .where( institution: current_institution, date: params[ :date_start ]..params[ :date_end ] )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
  end

  def delete # Удаление документа
    id = params[ :id ]

    ActiveRecord::Base.transaction do
      MenuProduct.where( menu_requirement_id: id ).delete_all
      MenuChildrenCategory.where( menu_requirement_id: id ).delete_all
      MenuMealsDish.where( menu_requirement_id: id ).delete_all
      MenuRequirement.where( id: id ).delete_all
    end

    render json: { status: true }
  end

  def menu_products
    @empty_meal_id = Meal.find_by( code: '' ).id

    ###
    @menu_products = JSON.parse( @menu_requirement.menu_products
      .joins( { product: :products_type }, { menu_meals_dish: [ :meal, :dish ] }, :children_category )
      .select( :id, :product_id, :menu_meals_dish_id, :children_category_id,
        :count_plan, :count_fact,
        'menu_meals_dishes.meal_id', 'meals.name as meal_name',
        'menu_meals_dishes.dish_id', 'dishes.name as dish_name',
        'children_categories.name AS category_name',
        'products.products_type_id', 'products_types.name AS type_name',
        'products.name AS product_name' )
      .order( 'meals.priority', 'meals.name',
              'dishes.priority', 'dishes.name',
              'children_categories.priority', 'children_categories.name',
              'products_types.priority', 'products_types.name', 'products.name' )
      .to_json, symbolize_names: true )

    @price_products = JSON.parse( @menu_requirement.institution.price_products
      .select( 'DISTINCT ON(product_id) product_id', :price )
      .where('price_date <= ?', @menu_requirement.date )
      .order( :product_id, 'price_date DESC' )
      .to_json, symbolize_names: true )

    @products = @menu_products.group_by { | o | [ o[ :products_type_id ], o[ :product_id ] ] }
      .map{ | k, v | { type_id: k[0], type_name: v[ 0 ][ :type_name ],
        id: k[ 1 ], name: v[ 0 ][ :product_name ],
        price: @price_products.select { | pp | pp[ :product_id ] == k[ 1 ] }
          .fetch( 0, { price: 0 } ).fetch( :price ) } }

    @products_meals_dishes = @menu_products.group_by { | o | [ o[ :meal_id ], o[ :dish_id ] ] }
      .map{ | k, v | { meal_id: k[0], meal_name: v[ 0 ][ :meal_name ],
        dish_id: k[ 1 ], dish_name: v[ 0 ][ :dish_name ] } }

    @products_meals = @products_meals_dishes.group_by { | o | o[ :meal_id ] }
      .map{ | k, v | { id: k, name: v[ 0 ][ :meal_name ], count: v.size } }

    @products_categories = @menu_products.group_by { | o | o[ :children_category_id ] }
      .map{ | k, v | { id: k, name: v[ 0 ][ :category_name ] } }
  end

  def products # Отображение товаров
    @menu_requirement = MenuRequirement.find( params[ :id ] )

    @disabled_plan = @menu_requirement.number_sap.present?
    @disabled_fact = @menu_requirement.number_saf.present?

    @menu_children_categories = JSON.parse( @menu_requirement.menu_children_categories
      .joins( :children_category )
      .select( :id, :children_category_id,
               :count_all_plan, :count_exemption_plan,
               :count_all_fact, :count_exemption_fact,
               'children_categories.name' )
      .order( 'children_categories.priority', 'children_categories.name' )
      .to_json, symbolize_names: true )

    @children_day_costs = JSON.parse( ChildrenDayCost
      .select( 'DISTINCT ON(children_category_id) children_category_id', :cost )
      .where( 'cost_date <= ?', @menu_requirement.date )
      .order( :children_category_id, 'cost_date DESC' )
      .to_json, symbolize_names: true )

    @menu_meals_dishes = JSON.parse( @menu_requirement.menu_meals_dishes
      .joins( :meal, dish: :dishes_category )
      .left_joins( :menu_products )
      .select( :id,
              :is_enabled,
              'meals.id AS meals_id',
              'meals.name AS meals_name',
              'dishes.id AS dishes_id',
              'dishes.name AS dishes_name',
              'dishes_categories.id AS category_id',
              'dishes_categories.name AS category_name',
              'COALESCE( SUM( menu_products.count_plan ), 0) AS count_plan' )
      .where( 'dishes.code != ?', '')
      .where( 'meals.code != ?', '' )
      .group( :id, 'meals.id', 'dishes.id', 'dishes_categories.id' )
      .order( 'meals.priority', 'meals.name', 'dishes_categories.priority',
              'dishes_categories.name', 'dishes.priority', 'dishes.name' )
      .to_json, symbolize_names: true )

    @menu_meals = @menu_meals_dishes.group_by{ | o | o[ :meals_id ] }
      .map{ | k, v | { id: k, name: v[ 0 ][ :meals_name ] } }

    @menu_dishes = @menu_meals_dishes.group_by{ | o | [ o[ :category_id ], o[ :dishes_id ] ] }
      .map{ | k, v | { category_id: k[0], category_name: v[ 0 ][ :category_name ],
        id: k[ 1 ], name: v[ 0 ][ :dishes_name ] } }

    menu_products( )
  end

  def create_products
    id = params[ :id ]
    @menu_requirement = MenuRequirement.find( id )

    menu_meals_dishes = JSON.parse( @menu_requirement.menu_meals_dishes
      .left_outer_joins( :menu_products )
      .select( :id, :is_enabled, 'COUNT(menu_products.id) as count' )
      .order( :id )
      .group( :id )
      .to_json, symbolize_names: true )

    pcc = JSON.parse( @menu_requirement.menu_children_categories
      .select( :children_category_id, 'products.id as product_id' )
      .joins( 'LEFT JOIN products ON true' )
      .order( :id, 'products.name' )
      .to_json, symbolize_names: true )

    now = Time.now.to_s( :db )

    sql_add_values = ''
    sql_del_values = ''
    menu_meals_dishes.each do | mmd |
      if mmd[ :is_enabled ] && mmd[ :count ].zero?
        pcc.each{ | o |
          sql_add_values += ",(#{ id },#{ mmd[ :id ] },#{ o[ :children_category_id ] },#{ o[ :product_id ] },'#{ now }','#{ now }')" }
      end


      sql_del_values += ",#{ mmd[ :id ] }" if mmd[ :is_enabled ] == false && mmd[ :count ].nonzero?
    end

    fieds = %w( menu_requirement_id menu_meals_dish_id
                children_category_id product_id created_at updated_at ).join( ',' )

    sql = ( sql_add_values.present? ? "INSERT INTO menu_products ( #{ fieds } ) VALUES #{ sql_add_values[1..-1] }" : '' ) +
      ( sql_add_values.present? && sql_del_values.present? ? ';' : '' ) +
      ( sql_del_values.present? ? "DELETE FROM menu_products WHERE menu_meals_dish_id IN (#{ sql_del_values[1..-1] })" : '' )

    ActiveRecord::Base.connection.execute( sql )

    menu_products( )
  end

  def create # Создание документа
    result = { }

    meals_dishes = JSON.parse( Meal
      .select( 'meals.id as meal_id', 'dishes.id as dish_id' )
      .joins( 'LEFT JOIN dishes ON true' )
      .order( 'meals.priority', 'meals.name', 'dishes.priority', 'dishes.name' )
      .to_json, symbolize_names: true )

    children_categories = JSON.parse( current_institution.children_categories
        .select( :id ).order( :name ).to_json, symbolize_names: true )

    if meals_dishes.present? && children_categories.present?
      ActiveRecord::Base.transaction do
        menu_requirement = MenuRequirement.create!( institution: current_institution, branch: current_branch )

        id = menu_requirement.id
        now = Time.now.to_s( :db )

        # Создание запроса для блюд
        mmd_sql_values = ''
        meals_dishes.each{ | md |
          mmd_sql_values += ",(#{ id },#{ md[ :meal_id ] },#{ md[ :dish_id ] },'#{ now }','#{ now }')"
        }

        mmd_fieds = %w( menu_requirement_id meal_id dish_id created_at updated_at ).join( ',' )
        mmd_sql = "INSERT INTO menu_meals_dishes ( #{ mmd_fieds } ) VALUES #{ mmd_sql_values[1..-1] }"

        # Создание запроса для категорий
        cc_sql_values = ''
        children_categories.each{ | cc |
          cc_sql_values += ",(#{ id },#{ cc[ :id ] },'#{ now }','#{ now }')"
        }

        cc_fieds = %w( menu_requirement_id children_category_id created_at updated_at ).join( ',' )
        cc_sql = "INSERT INTO menu_children_categories ( #{ cc_fieds } ) VALUES #{ cc_sql_values[1..-1] }"

        ActiveRecord::Base.connection.execute( "#{ mmd_sql };#{ cc_sql }" )
        result = { status: true, urlParams: { id: id } }
      end
    else
      result = { status: false, message: 'Незаповенені довідники (children_categories,meals,dishes)!' }
    end
    render json: result
  end

  def children_category_update # Обновление количества по категориям
    update = params.permit( :count_all_plan, :count_exemption_plan, :count_all_fact, :count_exemption_fact ).to_h
    MenuChildrenCategory.find( params[:id] ).update( update ) if params[ :id ] && update.present?
    render json: { status: true }
  end

  def product_update # Обновление количества по продуктам
    update = params.permit( :count_plan, :count_fact ).to_h
    MenuProduct.find( params[:id] ).update( update ) if params[ :id ] && update.present?
    render json: { status: true }
  end

  def update # Обновление реквизитов документа
    update = params.permit( :splendingdate ).to_h
    MenuRequirement.find( params[:id] ).update( update ) if params[:id] && update.any?
    render json: { status: true  }
  end

  def meals_dish_update #
    update = params.permit( :is_enabled ).to_h
    MenuMealsDish.find( params[:id] ).update( update ) if params[:id] && update.any?
    render json: { status: true }
  end

  def send_sap # Веб-сервис отправки плана меню-требования
    menu_requirement = MenuRequirement.find( params[:id] )

    menu_children_categories = JSON.parse( menu_requirement.menu_children_categories
      .joins( :children_category )
      .select( :count_all_plan, :count_exemption_plan, 'children_categories.code as code' )
      .where.not( count_all_plan: 0 )
      .or( menu_requirement.menu_children_categories
        .joins( :children_category )
        .select( :count_all_plan, :count_exemption_plan, 'children_categories.code as code' )
        .where.not( count_exemption_plan: 0 ) )
      .to_json, symbolize_names: true )

    menu_products = JSON.parse( menu_requirement.menu_products
      .joins( :children_category, :product )
      .select( :count_plan, 'products.code AS product_code', 'children_categories.code AS category_code' )
      .where.not( count_plan: 0 )
      .to_json, symbolize_names: true )

    if menu_children_categories.present? && menu_products.present?
      message = { 'CreateRequest' => { 'Branch_id' => menu_requirement.institution.branch.code,
                                       'Institutions_id' =>  menu_requirement.institution.code,
                                       'SplendingDate' => menu_requirement.splendingdate,
                                       'Date' => menu_requirement.date,
                                       'Goods' => menu_products.map { | o | {
                                         'CodeOfCategory' => o[ :category_code ],
                                         'CodeOfGoods' => o[ :product_code ],
                                         'Quantity' => o[ :count_plan ].to_s } },
                                       'Categories' => menu_children_categories.map { | o | {
                                         'CodeOfCategory' => o[ :code ],
                                         'QuantityAll' => o[ :count_all_plan ],
                                         'QuantityExemption' => o[ :count_exemption_plan ] } },
                                       'NumberFromWebPortal' => menu_requirement.number,
                                       'User' => current_user.username } }
      method_name = :create_menu_requirement_plan
      response = Savon.client( SAVON )
                   .call( method_name, message: message )
                   .body[ "#{ method_name }_response".to_sym ][ :return ]

      web_service = { call: { savon: SAVON, method: method_name.to_s.camelize, message: message } }

      if response[ :interface_state ] == 'OK'
        menu_requirement.update( date_sap: Date.today, number_sap: response[ :respond ] )
        menu_requirement.menu_children_categories
          .update_all( 'count_all_fact = count_all_plan, count_exemption_fact = count_exemption_plan' )
        menu_requirement.menu_products.update_all( 'count_fact = count_plan' )
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

  def send_saf # Веб-сервис отправки факта меню-требования
    menu_requirement = MenuRequirement.find( params[:id] )

    menu_children_categories = JSON.parse( menu_requirement.menu_children_categories
      .joins( :children_category )
      .select( :count_all_fact, :count_exemption_fact, 'children_categories.code as code' )
      .where.not( count_all_fact: 0 )
      .or( menu_requirement.menu_children_categories
        .joins( :children_category )
        .select( :count_all_fact, :count_exemption_fact, 'children_categories.code as code' )
        .where.not( count_exemption_fact: 0 ) )
      .to_json, symbolize_names: true )

    menu_products = JSON.parse( menu_requirement.menu_products
      .joins( :children_category, :product )
      .select( :count_fact, 'products.code AS product_code', 'children_categories.code AS category_code' )
      .where.not( count_plan: 0 )
      .to_json, symbolize_names: true )

    if menu_children_categories && menu_products
      message = { 'CreateRequest' => { 'Branch_id' => menu_requirement.institution.branch.code,
                                       'Institutions_id' =>  menu_requirement.institution.code,
                                       'SplendingDate' =>menu_requirement.splendingdate,
                                       'Date' => menu_requirement.date,
                                       'Goods' => menu_products.map{ | o | {
                                         'CodeOfCategory' => o[ :category_code ],
                                         'CodeOfGoods' => o[ :product_code ],
                                         'Quantity' => o[ :count_fact ].to_s } },
                                       'Categories' => menu_children_categories.map { | o | {
                                         'CodeOfCategory' => o[ :code ],
                                         'QuantityAll' => o[ :count_all_fact ],
                                         'QuantityExemption' => o[ :count_exemption_fact ] } },
                                       'NumberFromWebPortal' => menu_requirement.number,
                                       'User' => current_user.username } }

      method_name = :create_menu_requirement_fact
      response = Savon.client( SAVON )
                   .call( method_name, message: message )
                   .body[ "#{ method_name }_response".to_sym ][ :return ]

      web_service = { call: { savon: SAVON, method: method_name.to_s.camelize, message: message } }

      if response[ :interface_state ] == 'OK'
        menu_requirement.update( date_saf: Date.today, number_saf: response[ :respond ] )
        menu_requirement.menu_children_categories
          .where( count_all_plan: 0, count_exemption_plan: 0, count_all_fact: 0, count_exemption_fact: 0 ).delete_all
        menu_requirement.menu_products.where( count_plan: 0, count_fact: 0 ).delete_all
        menu_requirement.menu_meals_dishes.where( is_enabled: false ).delete_all
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
