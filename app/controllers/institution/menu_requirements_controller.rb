class Institution::MenuRequirementsController < Institution::BaseController
  def index ; end

  def ajax_filter_menu_requirements # Фильтрация документов
    @menu_requirements = MenuRequirement
      .where( institution_id: current_user[ :userable_id ],
              date: params[ :date_start ]..params[ :date_end ] )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
  end

  def delete # Удаление документа
    MenuRequirement.find( params[ :id ] ).destroy
    render json: { status: true }
  end

  def menu_products
    @mp = JSON.parse( MenuProduct
      .joins( { product: :products_type }, { menu_meals_dish: [ :meal, :dish ] }, :children_category )
      .select( :id, :product_id, :menu_meals_dish_id, :children_category_id,
        :count_plan, :count_fact,
        'menu_meals_dishes.meal_id', 'meals.name as meal_name',
        'menu_meals_dishes.dish_id', 'dishes.name as dish_name',
        'children_categories.name AS category_name',
        'products.products_type_id', 'products_types.name AS type_name',
        'products.name AS product_name' )
      .where( 'menu_meals_dishes.menu_requirement_id = ? ', @menu_requirement_id )
      .order( 'meals.priority', 'meals.name',
              'dishes.priority', 'dishes.name',
              'children_categories.priority', 'children_categories.name',
              'products_types.priority', 'products_types.name', 'products.name' )
      .to_json, symbolize_names: true )

    @price_products = JSON.parse( PriceProduct
      .select( 'DISTINCT ON(product_id) product_id', :price )
      .where( institution_id: current_user[ :userable_id ] )
      .where( 'price_date <= ?', @menu_requirement.date )
      .order( :product_id, 'price_date DESC' )
      .to_json, symbolize_names: true )

    @menu_products = @mp.group_by { | o | [ o[ :products_type_id ], o[ :product_id ] ] }
      .map{ | k, v | { type_id: k[0], type_name: v[ 0 ][ :type_name ],
        id: k[ 1 ], name: v[ 0 ][ :product_name ],
        price: @price_products.select { | pp | pp[ :product_id ] == k[ 1 ] }
          .fetch( 0, { price: 0 } ).fetch( :price ) } }

    @mp_meals_dishes = @mp.group_by { | o | [ o[ :meal_id ], o[ :dish_id ] ] }
      .map{ | k, v | { meal_id: k[0], meal_name: v[ 0 ][ :meal_name ],
        dish_id: k[ 1 ], dish_name: v[ 0 ][ :dish_name ] } }

    @mp_meals = @mp_meals_dishes.group_by { | o | o[ :meal_id ] }
      .map { | k, v | { id: k, name: v[ 0 ][ :meal_name ], count: v.size } }

    @mp_categories = @mp.group_by { | o | o[ :children_category_id ] }
      .map{ | k, v | { id: k, name: v[ 0 ][ :category_name ] } }
  end

  def products # Отображение товаров
    @menu_requirement = MenuRequirement.find( params[ :id ] )

    @menu_requirement_id = @menu_requirement.id
    @disabled_plan = @menu_requirement.number_sap.present?
    @disabled_fact = @menu_requirement.number_saf.present?

    @menu_children_categories = JSON.parse( MenuChildrenCategory
      .joins( :children_category )
      .select( :id, :children_category_id,
               :count_all_plan, :count_exemption_plan,
               :count_all_fact, :count_exemption_fact,
               'children_categories.name' )
      .where( menu_requirement_id: @menu_requirement_id )
      .order( 'children_categories.priority', 'children_categories.name' )
      .to_json, symbolize_names: true )

    @children_day_costs = JSON.parse( ChildrenDayCost
      .select( 'DISTINCT ON(children_category_id) children_category_id', :cost )
      .where( 'cost_date <= ?', @menu_requirement.date )
      .order( :children_category_id, 'cost_date DESC' )
      .to_json, symbolize_names: true )

    menu_meals_dishes( )
    menu_products( )
  end

  def menu_meals_dishes # Отображение приемов пищи и блюд
    @menu_meals_dishes = JSON.parse( MenuMealsDish
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
      .where( menu_requirement_id: @menu_requirement_id )
      .group( :id, 'meals.id', 'dishes.id', 'dishes_categories.id' )
      .order( 'meals.priority', 'meals.name', 'dishes_categories.priority',
              'dishes_categories.name', 'dishes.priority', 'dishes.name' )
      .to_json, symbolize_names: true )

    @menu_meals = @menu_meals_dishes.group_by{ | o | o[ :meals_id ] }
      .map{ | k, v | { id: k, name: v[ 0 ][ :meals_name ] } }

    @menu_dishes = @menu_meals_dishes.group_by{ | o | [ o[ :category_id ], o[ :dishes_id ] ] }
      .map{ | k, v | { category_id: k[0], category_name: v[ 0 ][ :category_name ],
        id: k[ 1 ], name: v[ 0 ][ :dishes_name ] } }
  end

  def create_products
    @menu_requirement_id = params[ :id ]
    @menu_requirement = MenuRequirement.find( @menu_requirement_id )

    menu_meals_dishes = JSON.parse( MenuMealsDish
      .left_outer_joins( :menu_products )
      .select( :id, :dish_id, :is_enabled, 'COUNT(menu_products.id) as count' )
      .where( menu_requirement_id: @menu_requirement_id )
      .order( :id )
      .group( :id )
      .to_json, symbolize_names: true )

    product_categories = JSON.parse( MenuChildrenCategory
      .select( :children_category_id, 'products.id as product_id' )
      .joins( 'LEFT JOIN products ON true' )
      .where( menu_requirement_id: @menu_requirement_id )
      .order( :id, 'products.name' )
      .to_json, symbolize_names: true )

    if false
      dishes_products_norms = JSON.parse( DishesProductsNorm
        .joins( :dishes_product )
        .select( :children_category_id, :amount,
                'dishes_products.dish_id', 'dishes_products.product_id' )
        .where( 'dishes_products.institution_id = ?', current_user[ :userable_id ] )
        .where( 'dishes_products.enabled = ?', true )
        .order( 'dishes_products.dish_id',
                'dishes_products.product_id',
                :children_category_id )
        .to_json, symbolize_names: true )
    else
      dishes_products_norms = JSON.parse( MenuMealsDish
        .select( :dish_id,
                  'menu_children_categories.children_category_id AS children_category_id',
                  'products.id AS product_id',
                  '0 AS amount' )
        .joins( 'LEFT JOIN products ON true' )
        .joins( 'LEFT JOIN menu_children_categories ON menu_children_categories.menu_requirement_id = menu_meals_dishes.menu_requirement_id' )
        .where( menu_requirement_id: @menu_requirement_id,
                is_enabled: true )
        .order( :dish_id,
                'products.id',
                'menu_children_categories.children_category_id' )
        .to_json, symbolize_names: true )
    end

    mcc_count = JSON.parse( MenuChildrenCategory
      .select( :children_category_id, :count_all_plan )
      .where( menu_requirement_id: @menu_requirement_id )
      .where.not( count_all_plan: 0 )
      .to_json( except: :id ), symbolize_names: true )
      .map { | o | o.values }
      .to_h

    add_values = [ ]
    del_values = [ ]

    menu_meals_dishes.each do | mmd |
      dish_id = mmd[ :dish_id ]
      if mmd[ :is_enabled ] && mmd[ :count ].zero?

        dishes_products_norms
        .select{ | o | o[ :dish_id ] == dish_id }
        .each { | dpn |
          children_category_id = dpn[ :children_category_id ]
          product_id = dpn[ :product_id ]
          norm = dpn[ :amount ]

          count_children = mcc_count[ children_category_id ] || 0

          count_plan = norm.to_f * count_children.to_i

          add_values << [ ].tap { | value |
            value << mmd[ :id ]
            value << children_category_id
            value << product_id
            value << count_plan
          }
        }
      end

      del_values << mmd[ :id ] if mmd[ :is_enabled ] == false && mmd[ :count ].nonzero?
    end

    sql = ''
    if add_values.any?
      sql_add_values = add_values.map { | o | "( #{ o.join( ',' ) } )" }.join( ',' )

      sql << <<-SQL.squish
        INSERT INTO menu_products ( menu_meals_dish_id, children_category_id, product_id, count_plan )
          VALUES #{ sql_add_values } ;
        SQL
    end

    if del_values.any?
      sql_add_values = del_values.join( ',' )

      sql << <<-SQL.squish
          DELETE FROM menu_products WHERE menu_meals_dish_id IN (#{ sql_add_values }) ;
        SQL
    end

    # File.open( "sql", 'w' ) { | f | f.write( sql.to_json ) }

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

    children_categories = JSON.parse( ChildrenCategory
      .joins( :children_groups )
      .select( :id )
      .where( 'children_groups.institution_id = ?', current_user[ :userable_id ] )
      .group( :id )
      .order( :name )
      .to_json, symbolize_names: true )

    dishes_products = JSON.parse( DishesProduct
      .select( :dish_id )
      .where( institution_id: current_user[ :userable_id ] )
      .group( :id )
      .having( 'bool_or( enabled ) = true' )
      .order( :dish_id )
      .to_json, symbolize_names: true )

    if meals_dishes.present? && children_categories.present? && dishes_products.present?
      ActiveRecord::Base.transaction do
        data = { institution_id: current_user[ :userable_id ],
                 branch_id: current_institution[ :branch_id ] }
        id = insert_base_single( 'menu_requirements', data )

        # Создание запроса для блюд
        mmd_sql_values = ''

        empty_meal_id = Meal.find_by( code: '' ).id
        empty_dish_id = Dish.find_by( code: '' ).id

        meals_dishes.each{ | md |
          mmd_sql_values += ",(#{ id },#{ md[ :meal_id ] },#{ md[ :dish_id ] })" if
              ( md[ :meal_id ] != empty_meal_id && md[ :dish_id ] != empty_dish_id ||
              md[ :meal_id ] == empty_meal_id && md[ :dish_id ] == empty_dish_id )&&
              dishes_products.find { | o | o[ :dish_id ] == md[ :dish_id ] }
        }

        mmd_sql = <<-SQL.squish
            INSERT INTO menu_meals_dishes ( menu_requirement_id, meal_id, dish_id )
              VALUES #{ mmd_sql_values[1..-1] }
          SQL

        # Создание запроса для категорий
        cc_sql_values = ''
        children_categories.each{ | cc |
          cc_sql_values << ",(#{ id },#{ cc[ :id ] })"
        }

        cc_fieds = %w( menu_requirement_id children_category_id ).join( ',' )
        cc_sql = <<-SQL.squish
            INSERT INTO menu_children_categories ( #{ cc_fieds } )
            VALUES #{ cc_sql_values[1..-1] }
          SQL

        ActiveRecord::Base.connection.execute( "#{ mmd_sql };#{ cc_sql }" )

        href = institution_menu_requirements_products_path( { id: id } )
        result = { status: true, href: href }
      end
    else
      result = { status: false,
        message: 'Незаповенені довідники (children_categories,meals,dishes,institutions_dishes_products)!' }
    end

   render json: result
  end

  def children_category_update # Обновление количества по категориям
    data = params.permit( :count_all_plan, :count_exemption_plan, :count_all_fact, :count_exemption_fact ).to_h
    status = update_base_with_id( :menu_children_categories, params[ :id ], data )
    render json: { status: status }
  end

  def product_update # Обновление количества по продуктам
    data = params.permit( :count_plan, :count_fact ).to_h
    status = update_base_with_id( :menu_products, params[ :id ], data )
    render json: { status: status }
  end

  def update # Обновление реквизитов документа
    data = params.permit( :splendingdate ).to_h
    status = update_base_with_id( :menu_requirements, params[ :id ], data )
    render json: { status: status }
  end

  def meals_dish_update #
    data = params.permit( :is_enabled ).to_h
    status = update_base_with_id( :menu_meals_dishes, params[ :id ], data )
    render json: { status: status }
  end

  def send_sap # Веб-сервис отправки плана меню-требования
    menu_requirement_id = params[ :id ]

    menu_requirement = JSON.parse( MenuRequirement
      .select( :number, :splendingdate, :date )
      .find( menu_requirement_id )
    .to_json, symbolize_names: true )

    splendingdate = menu_requirement[ :splendingdate  ]

    menu_requirement_exists = JSON.parse( MenuRequirement
      .select( :id, :number, :date, :number_sap, :date_sap, :number_saf, :date_saf )
      .where( splendingdate: splendingdate,
              institution_id: current_user[ :userable_id ],
              is_del_plan_1c: false )
      .where.not( id: menu_requirement_id,
                  number_saf: '' )
      .to_json, symbolize_names: true )

    if menu_requirement_exists.present?
      result = { status: false, caption: "За вибрану дату списання #{ date_str( splendingdate.to_date ) } уже відправлені в ІС документи",
        message: menu_requirement_exists.map { | v | {
            id: v[ :id ],
            'Номер': v[ :number ],
            'Дата:': date_str( v[ :date ].to_date ),
            'Номер IC план': v[ :number_sap ],
            'Дата IC план': date_str( v[ :date_sap ].to_date ),
            'Номер IC факт': v[ :number_saf ],
            'Дата IC факт': date_str( v[ :date_saf ].to_date )
        } }
      }
    else
      menu_children_categories = JSON.parse( MenuChildrenCategory
        .joins( :children_category )
        .select( :count_all_plan, :count_exemption_plan, 'children_categories.code as code' )
        .where( menu_requirement_id: menu_requirement_id )
        .where.not( count_all_plan: 0 )
        .or( MenuChildrenCategory
          .joins( :children_category )
          .select( :count_all_plan, :count_exemption_plan, 'children_categories.code as code' )
          .where( menu_requirement_id: menu_requirement_id )
          .where.not( count_exemption_plan: 0 ) )
        .to_json, symbolize_names: true )

      menu_products = JSON.parse( MenuMealsDish
        .joins( menu_products: [ :children_category, :product ] )
        .select( 'SUM( menu_products.count_plan ) AS count_plan',
                 'products.code AS product_code',
                 'children_categories.code AS category_code' )
        .where( menu_requirement_id: menu_requirement_id )
        .where( 'menu_products.count_plan != ? ', 0 )
        .group( 'products.code',
                'children_categories.code' )
        .to_json, symbolize_names: true )

      if menu_children_categories.present? && menu_products.present?
        categories = menu_children_categories.map { | o | { 'CodeOfCategory' => o[ :code ],
                                                            'QuantityAll' => o[ :count_all_plan ].to_s,
                                                            'QuantityExemption' => o[ :count_exemption_plan ].to_s } }

        goods = menu_products.map { | o | { 'CodeOfCategory' => o[ :category_code ],
                                          'CodeOfGoods' => o[ :product_code ],
                                          'Quantity' => o[ :count_plan ] } }

        message = { 'CreateRequest' => { 'Branch_id' => current_branch[ :code ],
                                        'Institutions_id' =>  current_institution[ :code ],
                                        'SplendingDate' => menu_requirement[ :splendingdate ],
                                        'Date' => menu_requirement[ :date ],
                                        'Goods' => goods,
                                        'Categories' =>  categories,
                                        'NumberFromWebPortal' => menu_requirement[ :number ],
                                        'User' => current_user[ :username ] } }
        savon_return = get_savon( :create_menu_requirement_plan, message )
        response = savon_return[ :response ]
        web_service = savon_return[ :web_service ]

        ###
        File.open( 'menu_requirement_plan.txt', 'a' ) { | f |
          f.write( "\n #{ web_service.merge!( response: response ).to_json }" )
        }
        ###

        if response[ :interface_state ] == 'OK'
          ActiveRecord::Base.transaction do
            data_menu_requirement = { date_sap: Date.today, number_sap: response[ :respond ].to_s }
            update_base_with_id( :menu_requirements, menu_requirement_id, data_menu_requirement )

            sql = 'UPDATE menu_children_categories ' +
                  'SET count_all_fact = count_all_plan, ' +
                      'count_exemption_fact = count_exemption_plan ' +
                      "WHERE menu_requirement_id = #{ menu_requirement_id };" +
                  'UPDATE menu_products ' +
                  'SET count_fact = count_plan ' +
                    'FROM menu_meals_dishes bb ' +
                    'WHERE menu_meals_dish_id = bb.id '+
                      "AND bb.menu_requirement_id = #{ menu_requirement_id }"

              ActiveRecord::Base.connection.execute( sql )
            end
          result = { status: true }
        else
          result = { status: false, caption: 'Неуспішна сихронізація з ІС',
                    message: web_service.merge!( response: response ) }
        end
      else
        result = { status: false, caption: 'Кількість не проставлена' }
      end
    end
    render json: result
  end

  def send_saf # Веб-сервис отправки факта меню-требования
    menu_requirement_id = params[ :id ]

    menu_requirement = JSON.parse( MenuRequirement
      .select( :number, :splendingdate, :date )
      .find( menu_requirement_id )
    .to_json, symbolize_names: true )

    menu_children_categories = JSON.parse( MenuChildrenCategory
      .joins( :children_category )
      .select( :count_all_fact, :count_exemption_fact, 'children_categories.code as code' )
      .where( menu_requirement_id: menu_requirement_id )
      .where.not( count_all_fact: 0 )
      .or( MenuChildrenCategory
        .joins( :children_category )
        .select( :count_all_fact, :count_exemption_fact, 'children_categories.code as code' )
        .where( menu_requirement_id: menu_requirement_id )
        .where.not( count_exemption_fact: 0 ) )
      .to_json, symbolize_names: true )

    menu_products = JSON.parse( MenuMealsDish
      .joins( menu_products: [ :children_category, :product ] )
      .select( 'SUM( menu_products.count_fact ) as count_fact',
               'products.code AS product_code',
               'children_categories.code AS category_code' )
      .where( menu_requirement_id: menu_requirement_id )
      .where( '( menu_products.count_fact != ? OR menu_products.count_plan != ? )', 0, 0 )
      .group( 'products.code',
              'children_categories.code' )
      .to_json, symbolize_names: true )

    if menu_children_categories && menu_products

      goods = menu_products.map{ | o | { 'CodeOfCategory' => o[ :category_code ],
                                        'CodeOfGoods' => o[ :product_code ],
                                        'Quantity' => o[ :count_fact ] } }

      categories = menu_children_categories.map { | o | { 'CodeOfCategory' => o[ :code ],
                                                          'QuantityAll' => o[ :count_all_fact ],
                                                          'QuantityExemption' => o[ :count_exemption_fact ] } }

      message = { 'CreateRequest' => { 'Branch_id' => current_branch[ :code ],
                                       'Institutions_id' =>  current_institution[ :code],
                                       'SplendingDate' =>menu_requirement[ :splendingdate ],
                                       'Date' => menu_requirement[ :date ],
                                       'Goods' => goods,
                                       'Categories' => categories,
                                       'NumberFromWebPortal' => menu_requirement[ :number ],
                                       'User' => current_user[ :username ] } }
      savon_return = get_savon( :create_menu_requirement_fact, message )
      response = savon_return[ :response ]
      web_service = savon_return[ :web_service ]

      ###
      File.open( 'menu_requirement_fact.txt', 'a' ) { | f |
        f.write( "\n #{ web_service.merge!( response: response ).to_json }" )
      }
      ###

      if response[ :interface_state ] == 'OK'
        ActiveRecord::Base.transaction do
          data_menu_requirement = { date_saf: Date.today, number_saf: response[ :respond ].to_s }
          update_base_with_id( :menu_requirements, menu_requirement_id, data_menu_requirement )

            MenuChildrenCategory
              .where( menu_requirement_id: menu_requirement_id,
                      count_all_plan: 0,
                      count_exemption_plan: 0,
                      count_all_fact: 0,
                      count_exemption_fact: 0 )
              .delete_all

            MenuMealsDish
              .where( menu_requirement_id: menu_requirement_id,
                      is_enabled: false )
              .delete_all

            sql = 'DELETE FROM menu_products ' +
                    'USING menu_meals_dishes bb ' +
                    'WHERE menu_meals_dish_id = bb.id '+
                      "AND bb.menu_requirement_id = #{ menu_requirement_id } " +
                      'AND count_plan = 0 '+
                      'AND count_fact = 0'

            ActiveRecord::Base.connection.execute( sql )
          end
        result = { status: true }
      else
        result = { status: false, caption: 'Неуспішна сихронізація з ІС',
                   message: web_service.merge!( response: response ) }
      end
    else
      result = { status: false, caption: 'Кількість не проставлена' }
    end

    render json: result
  end

  def print
    menu_requirement_id = params[ :id ]

    data = MenuRequirement
      .joins( institution: :branch )
      .select( :number, :date, :splendingdate, :date_sap, :date_saf,
                'branches.name AS branch_name',
                'institutions.name AS institution_name' )
      .find( menu_requirement_id )
      .as_json( except: :id )
      .merge!( children_categories: MenuChildrenCategory
        .joins( :children_category )
        .select( 'children_categories.name',
                :count_all_plan, :count_exemption_plan,
                :count_all_fact, :count_exemption_fact )
        .where( menu_requirement_id: menu_requirement_id )
        .order( 'children_categories.priority', 'children_categories.name' )
        .as_json( except: :id ) )
      .merge!( products: MenuProduct
        .joins( { product: :products_type },
                { menu_meals_dish: [ :meal, :dish ] },
                :children_category )
        .select( 'meals.name as meal_name',
                  'dishes.name as dish_name',
                  'children_categories.name AS category_name',
                  'products_types.name AS type_name',
                  'products.name AS product_name',
                  :count_plan, :count_fact )
        .where( 'menu_meals_dishes.menu_requirement_id = ? ', menu_requirement_id )
        .order( 'meals.priority', 'meals.name',
                'dishes.priority', 'dishes.name',
                'children_categories.priority', 'children_categories.name',
                'products_types.priority', 'products_types.name', 'products.name' )
        .as_json( except: :id ) )
      .to_json

    message = { "CreateRequest" => { "json" => data } }

    savon_return = get_savon( :get_print_form_of_menu_requirement, message )
    response = savon_return[ :response ]
    web_service = savon_return[ :web_service ]

    render json: response[ :interface_state ] == 'OK' ?
      { status: true, href: response[ :respond ] }
      :
      { status: false, caption: 'Неуспішна сихронізація з ІС',
        message: web_service.merge!( response: response ) }
  end

end
