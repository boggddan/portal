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

  def create_products
    menu_requirement_id = params[ :id ]

    institution_id = current_user[ :userable_id ]

    @menu_requirement = JSON.parse( MenuRequirement
      .select( :id,
               :splendingdate )
      .find( menu_requirement_id )
      .to_json, symbolize_names: true )

    menu_meals_dishes = JSON.parse( MenuMealsDish
      .left_outer_joins( :menu_products )
      .select( :id, :dish_id, :is_enabled, 'COUNT(menu_products.id) as count' )
      .where( menu_requirement_id: menu_requirement_id )
      .order( :id )
      .group( :id )
      .to_json, symbolize_names: true )

    if true
      # Нормы
      sql_fields_distinct = %w(
        dishes_products_norms.children_category_id
        dishes_products.dish_id
        dishes_products.product_id
      ).join( ',' )

      sql_institution_empty = <<-SQL
          dishes_products.institution_id = ( SELECT id FROM institutions WHERE code = 0 )
        SQL

      sql_where = <<-SQL
          ( dishes_products.institution_id = #{ institution_id }
            OR #{ sql_institution_empty } )
          AND
            dishes_products_norms.children_category_id IN
              ( SELECT DISTINCT children_category_id FROM children_groups
                WHERE institution_id = #{ institution_id } )
          AND dishes_products.enabled = true
        SQL

      sql_order = <<-SQL
          #{ sql_fields_distinct },
          CASE WHEN #{ sql_institution_empty } THEN 0 ELSE 1 END DESC
        SQL

      dishes_products_norms = JSON.parse( DishesProduct
        .joins( :dishes_products_norms )
        .select(
          "DISTINCT ON( #{ sql_fields_distinct } ) dishes_products.dish_id",
          :product_id,
          'dishes_products_norms.children_category_id',
          'dishes_products_norms.amount'
        )
        .where( sql_where )
        .order( sql_order )
        .to_json, symbolize_names: true )

      ###
    else
      dishes_products_norms = JSON.parse( MenuMealsDish
        .select( :dish_id,
                  'menu_children_categories.children_category_id AS children_category_id',
                  'products.id AS product_id',
                  '0 AS amount' )
        .joins( 'LEFT JOIN products ON true' )
        .joins( 'LEFT JOIN menu_children_categories ON menu_children_categories.menu_requirement_id = menu_meals_dishes.menu_requirement_id' )
        .where( menu_requirement_id: menu_requirement_id,
                is_enabled: true )
        .order( :dish_id,
                'products.id',
                'menu_children_categories.children_category_id' )
        .to_json, symbolize_names: true )
    end

    menu_children_category = JSON.parse( MenuChildrenCategory
      .select( :children_category_id,
               :count_all_plan )
      .where( menu_requirement_id: menu_requirement_id )
      .where.not( count_all_plan: 0 )
      .to_json( except: :id ), symbolize_names: true )

    mcc_count = menu_children_category
      .map { | o | o.values }
      .to_h

    menu_products_add_values = [ ]
    menu_products_del_values = [ ]

    menu_meals_dishes.each do | mmd |
      dish_id = mmd[ :dish_id ]

      if mmd[ :is_enabled ] && mmd[ :count ].zero?

        dishes_products_norms
          .select{ | o | o[ :dish_id ] == dish_id }
          .each { | dpn |
            children_category_id = dpn[ :children_category_id ]
            product_id = dpn[ :product_id ]
            norm = dpn[ :amount ].to_f
            count_children = mcc_count[ children_category_id ].to_i || 0

            menu_products_add_values << [ ].tap { | value |
              value << mmd[ :id ]
              value << children_category_id
              value << product_id
              value << norm * count_children
            }
          }
      end

      if mmd[ :is_enabled ] == false && mmd[ :count ].nonzero?
        menu_products_del_values << mmd[ :id ]
      end
    end

    menu_products_sql = ''

    if menu_products_add_values.any?
      menu_products_sql_add_values = menu_products_add_values.map { | o | "( #{ o.join( ',' ) } )" }.join( ',' )

      menu_products_sql << <<-SQL.squish
        INSERT INTO menu_products ( menu_meals_dish_id, children_category_id, product_id, count_plan )
          VALUES #{ menu_products_sql_add_values } ;
        SQL
    end

    if menu_products_del_values.any?
      menu_products_sql_del_values = del_values.join( ',' )

      menu_products_sql << <<-SQL.squish
          DELETE FROM menu_products WHERE menu_meals_dish_id IN (#{ menu_products_sql_del_values }) ;
        SQL
    end

    ActiveRecord::Base.connection.execute( menu_products_sql ) if menu_products_sql

    #=================================

    sql_join_menu_products_price = <<-SQL.squish
        LEFT JOIN menu_products_prices
          ON menu_products_prices.product_id = menu_products.product_id AND
             menu_products_prices.menu_requirement_id = menu_meals_dishes.menu_requirement_id
      SQL

    products = JSON.parse( MenuProduct
      .joins( :menu_meals_dish,
              :product )
      .joins( sql_join_menu_products_price )
      .select( :product_id,
              'products.code',
              'menu_products_prices.id' )
      .where( 'menu_meals_dishes.menu_requirement_id = ? ', menu_requirement_id )
      .group( :product_id,
              'products.code',
              'menu_products_prices.id' )
      .to_json, symbolize_names: true )

    menu_products_prices_sql = ''
    menu_products_prices_add_values = [ ]
    menu_products_prices_not_del_product_ids = [ ]

    return_prices = get_actual_price( @menu_requirement[ :splendingdate ], products )

    actual_prices = return_prices[ :status ] ? return_prices[ :actual_prices ] : []

    products.each { | product |
      actual_price = actual_prices.find { | o | o[ :product ].strip == product[ :code ] }

      if actual_price
        price = actual_price[ :price ].to_f.truncate( 2 )
        balance = actual_price[ :quantity ].to_f.truncate( 3 )
      else
        price = 0
        balance = 0
      end

      menu_products_price_id = product[ :id ]
      product_id = product[ :product_id ]

      menu_products_prices_not_del_product_ids << product_id

      if menu_products_price_id
        menu_products_prices_sql << <<-SQL.squish
            UPDATE menu_products_prices
              SET price = #{ price },
                  balance =#{ balance }
              WHERE id = #{ menu_products_price_id } ;
          SQL
      else
        menu_products_prices_add_values << [ ].tap { | value |
          value << menu_requirement_id
          value << product_id
          value << price
          value << balance
        }
      end
     }

    if menu_products_prices_add_values.any?
      menu_products_prices_sql_add_values = menu_products_prices_add_values.map { | o | "( #{ o.join( ',' ) } )" }.join( ',' )
      menu_products_prices_sql << <<-SQL.squish
          INSERT INTO menu_products_prices ( menu_requirement_id, product_id, price, balance )
            VALUES #{ menu_products_prices_sql_add_values } ;

          DELETE FROM menu_products_prices WHERE NOT product_id IN ( #{ menu_products_prices_not_del_product_ids.join( ',' ) } )
        SQL
    end

    ActiveRecord::Base.connection.execute( menu_products_prices_sql ) if menu_products_prices_sql

    menu_products( menu_requirement_id )
  end

  def menu_products( menu_requirement_id )
    @menu_products = JSON.parse( MenuProduct
      .joins( { menu_meals_dish: [ :meal, :dish ] },
              :children_category )
      .select( :id,
              :product_id,
              :menu_meals_dish_id,
              :children_category_id,
              :count_plan,
              :count_fact,
              'menu_meals_dishes.meal_id',
              'meals.name as meal_name',
              'menu_meals_dishes.dish_id',
              'dishes.name as dish_name',
              'children_categories.name AS category_name' )
      .where( 'menu_meals_dishes.menu_requirement_id = ? ', menu_requirement_id )
      .order( 'meals.priority',
              'meals.name',
              'dishes.priority',
              'dishes.name',
              'children_categories.priority',
              'children_categories.name' )
      .to_json, symbolize_names: true )

    @menu_products_prices = JSON.parse( MenuProductsPrice
      .joins( { product: :products_type } )
      .select( :product_id,
               :price,
               :balance,
               'products.products_type_id',
               'products_types.name AS products_type_name',
               'products.name AS product_name' )
      .where( menu_requirement_id: menu_requirement_id )
      .order( 'products_types.priority',
              'products_types.name',
              'products.name' )
      .to_json, symbolize_names: true )

    @mp_meals_dishes = @menu_products.group_by { | o | [ o[ :meal_id ], o[ :dish_id ] ] }
      .map{ | k, v | { meal_id: k[0], meal_name: v[ 0 ][ :meal_name ],
        dish_id: k[ 1 ], dish_name: v[ 0 ][ :dish_name ] } }

    @mp_meals = @mp_meals_dishes.group_by { | o | o[ :meal_id ] }
      .map { | k, v | { id: k, name: v[ 0 ][ :meal_name ], count: v.size } }

    @mp_categories = @menu_products.group_by { | o | o[ :children_category_id ] }
      .map{ | k, v | { id: k, name: v[ 0 ][ :category_name ] } }
  end

  def products # Отображение товаров
    @menu_requirement = JSON.parse( MenuRequirement
      .select( :id,
               :number,
               :date,
               :splendingdate,
               :number_sap,
               :number_saf,
               :date_sap,
               :date_saf
                )
      .find( params[ :id ] )
      .to_json, symbolize_names: true )

    @menu_children_categories = JSON.parse( MenuChildrenCategory
      .joins( :children_category )
      .select( :id,
               :children_category_id,
               :count_all_plan,
               :count_exemption_plan,
               :count_all_fact,
               :count_exemption_fact,
               'children_categories.name' )
      .where( menu_requirement_id: @menu_requirement[ :id ] )
      .order( 'children_categories.priority',
              'children_categories.name' )
      .to_json, symbolize_names: true )

    @children_day_costs = JSON.parse( ChildrenDayCost
      .select( 'DISTINCT ON(children_category_id) children_category_id',
               :cost )
      .where( 'cost_date <= ?', @menu_requirement[ :date ] )
      .order( :children_category_id,
              cost_date: :desc )
      .to_json, symbolize_names: true )

    menu_meals_dishes( @menu_requirement[ :id ] )
    menu_products( @menu_requirement[ :id ] )
  end

  def menu_meals_dishes( menu_requirement_id ) # Отображение приемов пищи и блюд
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
      .where( menu_requirement_id: menu_requirement_id )
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

  def get_actual_price( date, products )
    #   .select { | o |
    #   [ "000000028", "000000063", "000000077", "000000110" ].include?( o[ :code ] )
    # }

    products<< { code: "000000028" }
    goods = products
      .map { | o | { 'Product' => o[ :code ] } }


      message = {
      'CreateRequest' => {
        'Branch_id' => current_branch[ :code ],
        'Institutions_id' => current_institution[ :code ],
        'Date' => date,
        'ArrayOfGoods' => goods
      }
    }

    savon_return = get_savon( :get_actual_price, message )
    response = savon_return[ :response ]
    web_service = savon_return[ :web_service ]

    actual_prices = response[ :array_of_goods ]

    if response[ :interface_state ] == 'OK'&& actual_prices
      result = { status: true, actual_prices: actual_prices }
    else
      result = { status: false, caption: 'Неуспішна сихронізація з ІС',
                 message: web_service.merge!( response: response ) }
    end

    return result
  end

  def update_price # Обновление остатков і цен продуктов
    menu_requirement = JSON.parse( MenuRequirement
      .select( :id, :splendingdate )
      .find( params[ :id ] )
      .to_json, symbolize_names: true )

    menu_products_price = JSON.parse( MenuProductsPrice
      .joins( :product )
      .select( :id,
               :product_id,
               :price,
               :balance,
               'products.code',
               'products.name' )
      .where( menu_requirement_id: menu_requirement[ :id ] )
      .order( 'products.name' )
      .to_json, symbolize_names: true )

    return_prices = get_actual_price( menu_requirement[ :splendingdate ], menu_products_price )

    if return_prices[ :status ]
      menu_products_prices_sql = ''

      actual_prices = return_prices[ :actual_prices ]
      prices_message = [ ]
      prices_data = [ ]

      menu_products_price.each { | mpp |
        actual_price = actual_prices.find { | o | o[ :product ].strip == mpp[ :code ] }

        if actual_price
          price = actual_price[ :price ].to_f.truncate( 2 )
          balance = actual_price[ :quantity ].to_f.truncate( 3 )

          if price != mpp[ :price ].to_f || balance != mpp[ :balance ].to_f
            prices_message << {
              'Продукт' => mpp[ :name ],
              'Ціна' => price,
              'Залишок' => balance
            }

            prices_data << {
              product_id: mpp[ :product_id ],
              price: price,
              balance: balance
            }

            menu_products_prices_sql << <<-SQL.squish
                UPDATE menu_products_prices
                  SET price = #{ price },
                      balance =#{ balance }
                  WHERE id = #{ mpp[ :id ] } ;
              SQL
          end
        end
      }

      if prices_data.any?
        # ActiveRecord::Base.connection.execute( menu_products_prices_sql )
        result = { status: true, caption: 'Оновлені продукти', message: prices_message, data: prices_data }
      else
        result = { status: true }
      end
    else
      result =  return_prices
    end

    render json: result
  end

  def create # Создание документа
    result = { }

    institution_id = current_user[ :userable_id ]

    meals_dishes = JSON.parse( Meal
      .select( 'meals.id as meal_id', 'dishes.id as dish_id' )
      .joins( 'LEFT JOIN dishes ON true' )
      .order( 'meals.priority', 'meals.name', 'dishes.priority', 'dishes.name' )
      .to_json, symbolize_names: true )

    children_categories = JSON.parse( ChildrenCategory
      .joins( :children_groups )
      .select( :id )
      .where( 'children_groups.institution_id = ?', institution_id )
      .group( :id )
      .order( :name )
      .to_json, symbolize_names: true )

    # Нормы
    sql_institution_empty = <<-SQL
        dishes_products.institution_id = ( SELECT id FROM institutions WHERE code = 0 )
      SQL

    sql_where = <<-SQL
        ( dishes_products.institution_id = #{ institution_id }
          OR #{ sql_institution_empty } )
        AND
          dishes_products_norms.children_category_id IN
            ( SELECT DISTINCT children_category_id FROM children_groups
              WHERE institution_id = #{ institution_id } )
      SQL

    dishes_products = JSON.parse( DishesProduct
      .joins( :dishes_products_norms )
      .select( 'DISTINCT ON( dishes_products.dish_id ) bool_or( enabled ) AS enabled',
               :dish_id )
      .where( sql_where )
      .group( :institution_id, :dish_id )
      .order( :dish_id,
             "CASE WHEN #{ sql_institution_empty } THEN 0 ELSE 1 END DESC" )
      .to_json, symbolize_names: true )
      .select{ | o | o[ :enabled ] }
    ###

    if children_categories.present? && ( dishes_products.present? || false )
      ActiveRecord::Base.transaction do
        data = { institution_id: institution_id,
                 branch_id: current_institution[ :branch_id ] }
        id = insert_base_single( 'menu_requirements', data )

        # Создание запроса для блюд
        mmd_values = [ ]

        empty_meal_id = Meal.find_by( code: '' ).id
        empty_dish_id = Dish.find_by( code: '' ).id

        meals_dishes
          .select{ | md |
            ( md[ :meal_id ] != empty_meal_id &&
              md[ :dish_id ] != empty_dish_id ||
              md[ :meal_id ] == empty_meal_id &&
              md[ :dish_id ] == empty_dish_id
            ) &&
            ( dishes_products.find { | o |
              o[ :dish_id ] == md[ :dish_id ]
            } || false )
          }
          .each{ | o |
            mmd_values << [ ].tap { | value |
                value << id
                value << o[ :meal_id ]
                value << o[ :dish_id ]
            }
          }

        sql = ''
        if mmd_values.any?
          mmd_sql_values = mmd_values.map { | o | "( #{ o.join( ',' ) } )" }.join( ',' )

          sql << <<-SQL.squish
              INSERT INTO menu_meals_dishes ( menu_requirement_id, meal_id, dish_id )
                VALUES #{ mmd_sql_values } ;
            SQL
        end

        # Создание запроса для категорий
        cc_values = [ ]

        children_categories.each { | o |
          cc_values << [ ].tap { | value |
            value << id
            value << o[ :id ]
          }
        }

        if cc_values.any?
          cc_sql_values = cc_values.map { | o | "( #{ o.join( ',' ) } )" }.join( ',' )

          sql << <<-SQL.squish
              INSERT INTO menu_children_categories ( menu_requirement_id, children_category_id )
                VALUES #{ cc_sql_values } ;
            SQL
        end

        ActiveRecord::Base.connection.execute( sql ) if sql

        href = institution_menu_requirements_products_path( { id: id } )
        result = { status: true, href: href }
      end
    else
      result = { status: false,
        message:
          "#{ children_categories.present? ? '' : 'Немає групп у підрозділі, заповнненя через ІС або web-servis <children_groups>. ' }" +
          "#{ dishes_products.present? ? '' : 'Невибрано жодної страви у <Довіднии -> Технологічна карта>. ' } "
      }
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
        .joins( 'LEFT JOIN menu_products_prices ON menu_products_prices.product_id = menu_products.product_id' )
        .select( 'SUM( menu_products.count_plan ) AS count_plan',
                 'SUM( menu_products.count_plan * menu_products_prices.price ) AS amount',
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
                                          'Quantity' => o[ :count_plan ],
                                          'Amount' => o[ :amount ] } }

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

      goods = menu_products.map { | o | { 'CodeOfCategory' => o[ :category_code ],
                                        'CodeOfGoods' => o[ :product_code ],
                                        'Quantity' => o[ :count_fact ],
                                        'Amount' => 0 }
    }

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
