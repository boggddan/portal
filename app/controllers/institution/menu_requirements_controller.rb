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

    @menu_requirement = JSON.parse( MenuRequirement
      .joins( institution: :branch )
      .select( :id,
               :splendingdate,
               :institution_id,
               'institutions.code AS institution_code',
               'branches.code AS branch_code' )
      .find( menu_requirement_id )
      .to_json, symbolize_names: true )

    menu_meals_dishes = JSON.parse( MenuMealsDish
      .left_outer_joins( :menu_products )
      .select( :id, :dish_id, :is_enabled, 'COUNT(menu_products.id) as count' )
      .where( menu_requirement_id: menu_requirement_id )
      .order( :id )
      .group( :id )
      .to_json, symbolize_names: true )

    sql = <<-SQL.squish
      SELECT aa.dish_id,
             dishes_products.product_id,
             dishes_products_norms.children_category_id,
             dishes_products_norms.amount
      FROM (
        SELECT DISTINCT ON( dish_id ) institution_dishes.id AS institution_dish_id,
               institution_dishes.dish_id,
               institution_dishes.enabled
        FROM institution_dishes
        INNER JOIN institutions ON institutions.id = institution_dishes.institution_id
        WHERE institutions.code = 0
              OR
              institution_dishes.institution_id = #{ @menu_requirement[ :institution_id ] }
        ORDER by dish_id,
                institutions.code DESC
      ) aa
      INNER JOIN dishes_products ON aa.institution_dish_id = dishes_products.institution_dish_id
      INNER JOIN products ON dishes_products.product_id = products.id
      INNER JOIN dishes_products_norms ON dishes_products.id = dishes_products_norms.dishes_product_id
      INNER JOIN (
        SELECT DISTINCT ON ( children_categories.id ) children_categories.id AS children_category_id
        FROM children_categories
        LEFT JOIN children_groups ON children_categories.id = children_groups.children_category_id
        WHERE children_groups.institution_id = #{ @menu_requirement[ :institution_id ] }
              AND
              children_groups.is_del = false
              AND
              children_categories.is_del = false
      ) bb ON dishes_products_norms.children_category_id = bb.children_category_id
      WHERE aa.enabled = true
            AND
            products.is_del = false
    SQL

    @dishes_products_norms = JSON.parse( ActiveRecord::Base.connection.execute( sql )
      .to_json, symbolize_names: true )

    menu_children_category = JSON.parse( MenuChildrenCategory
      .joins( :children_category )
      .select( :children_category_id,
               :count_all_plan )
      .where( menu_requirement_id: menu_requirement_id,
              children_categories: { is_del: false } )
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

        @dishes_products_norms
          .select{ | o | o[ :dish_id ] == dish_id }
          .each { | dpn |
            children_category_id = dpn[ :children_category_id ]
            product_id = dpn[ :product_id ]
            norm = dpn[ :amount ].to_d
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

    #================================
    sql_menu_products_price = <<-SQL.squish
      INSERT INTO menu_products_prices ( menu_requirement_id, product_id )
        SELECT menu_meals_dishes.menu_requirement_id,
               menu_products.product_id
          FROM menu_products
          LEFT JOIN menu_meals_dishes ON menu_products.menu_meals_dish_id = menu_meals_dishes.id
          LEFT JOIN menu_products_prices ON
            menu_products.product_id = menu_products_prices.product_id AND
            menu_meals_dishes.menu_requirement_id = menu_products_prices.menu_requirement_id
          WHERE menu_products_prices.id isnull AND
            menu_meals_dishes.menu_requirement_id = #{ menu_requirement_id }
          GROUP BY 1, 2;
        DELETE FROM menu_products_prices WHERE
          product_id NOT IN (
            SELECT DISTINCT product_id
              FROM menu_products
              LEFT JOIN menu_meals_dishes ON
                menu_products.menu_meals_dish_id = menu_meals_dishes.id
              WHERE menu_meals_dishes.menu_requirement_id = menu_products_prices.menu_requirement_id
          ) AND
          menu_requirement_id = #{ menu_requirement_id }
      SQL

    ActiveRecord::Base.connection.execute( sql_menu_products_price )
    update_prices( @menu_requirement ) # Обновление остатков і цен продуктов
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
      .where( menu_meals_dishes: { menu_requirement_id: menu_requirement_id } )
      .where.not( children_categories: { code: '000000027' } )
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
               :date_saf,
               :institution_id
            )
      .find( params[ :id ] )
      .to_json, symbolize_names: true )

    institution_id = @menu_requirement[ :institution_id ]

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
      .where.not( children_categories: { code: '000000027' } )
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

    sql = <<-SQL.squish
      SELECT aa.dish_id,
             dishes_products.product_id,
             dishes_products_norms.children_category_id,
             dishes_products_norms.amount
      FROM (
        SELECT DISTINCT ON( dish_id ) institution_dishes.id AS institution_dish_id,
               institution_dishes.dish_id,
               institution_dishes.enabled
        FROM institution_dishes
        INNER JOIN institutions ON institutions.id = institution_dishes.institution_id
        WHERE institutions.code = 0
              OR
              institution_dishes.institution_id = #{ institution_id }
        ORDER by dish_id,
                institutions.code DESC
      ) aa
      INNER JOIN dishes_products ON aa.institution_dish_id = dishes_products.institution_dish_id
      INNER JOIN dishes_products_norms ON dishes_products.id = dishes_products_norms.dishes_product_id
      INNER JOIN (
        SELECT DISTINCT ON ( children_categories.id ) children_categories.id AS children_category_id
        FROM children_categories
        LEFT JOIN children_groups ON children_categories.id = children_groups.children_category_id
        WHERE children_groups.institution_id = #{ institution_id }
              AND
              children_categories.code != '000000027'
      ) bb ON dishes_products_norms.children_category_id = bb.children_category_id
      WHERE aa.enabled = true
    SQL

    @dishes_products_norms = JSON.parse( ActiveRecord::Base.connection.execute( sql )
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

  def get_actual_price( menu_requirement, products )
    goods = products
      .map { | o | { 'Product' => o[ :code ] } }

    message = {
      'CreateRequest' => {
        'Branch_id' => menu_requirement[ :branch_code ],
        'Institutions_id' => menu_requirement[ :institution_code ],
        'Date' => menu_requirement[ :splendingdate ],
        'ArrayOfGoods' => goods
      }
    }

    savon_return = get_savon( :get_actual_price, message )
    response = savon_return[ :response ]
    web_service = savon_return[ :web_service ]

    array_of_goods = response[ :array_of_goods ]

    if response[ :interface_state ] == 'OK'&& array_of_goods
      actual_prices = array_of_goods.class == Hash ? [ ] << array_of_goods : array_of_goods
      result = { status: true, actual_prices: actual_prices }
    else
      result = { status: false, caption: 'Неуспішна сихронізація з ІС',
                 message: web_service.merge!( response: response ) }
    end

    return result
  end

  def update_prices( menu_requirement ) # Обновление остатков і цен продуктов
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

    return_prices = get_actual_price( menu_requirement, menu_products_price )

    if return_prices[ :status ]
      menu_products_prices_sql = ''

      actual_prices = return_prices[ :actual_prices ]
      prices_message = [ ]
      prices_data = [ ]

      menu_products_price.each { | mpp |
        actual_price = actual_prices.find { | o | o[ :product ].strip == mpp[ :code ] }

        if actual_price
          price = actual_price[ :price ].to_d.truncate( 5 )
          balance = actual_price[ :quantity ].to_d.truncate( 3 )

          if price != mpp[ :price ].to_d || balance != mpp[ :balance ].to_d
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
        ActiveRecord::Base.connection.execute( menu_products_prices_sql )
        result = { status: true, caption: 'Оновлені продукти', message: prices_message, data: prices_data }
      else
        result = { status: true }
      end
    else
      result =  return_prices
    end
  end

  def prices # Обновление остатков і цен продуктов
    menu_requirement = JSON.parse( MenuRequirement
      .joins( institution: :branch )
      .select( :id,
               :splendingdate,
               'institutions.code AS institution_code',
               'branches.code AS branch_code' )
      .find( params[ :id ] )
      .to_json, symbolize_names: true )

    result = update_prices( menu_requirement ) # Обновление остатков і цен продуктов

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
      .joins( children_groups: :children_category )
      .select( :id )
      .where( children_groups: { institution_id: institution_id, is_del: false },
              children_categories: { is_del: false } )
      .group( :id )
      .order( :name )
      .to_json, symbolize_names: true )

    # Нормы
    sql = <<-SQL.squish
        SELECT aa.dish_id,
               dishes_products.product_id,
               dishes_products_norms.children_category_id,
               dishes_products_norms.amount
        FROM (
          SELECT DISTINCT ON( dish_id ) institution_dishes.id AS institution_dish_id,
                 institution_dishes.dish_id,
                 institution_dishes.enabled
          FROM institution_dishes
          INNER JOIN institutions ON institutions.id = institution_dishes.institution_id
          WHERE institutions.code = 0
                OR
                institution_dishes.institution_id = #{ institution_id }
          ORDER by dish_id,
                  institutions.code DESC
        ) aa
        INNER JOIN dishes_products ON aa.institution_dish_id = dishes_products.institution_dish_id
        INNER JOIN products ON dishes_products.product_id = products.id
        INNER JOIN dishes_products_norms ON dishes_products.id = dishes_products_norms.dishes_product_id
        INNER JOIN (
          SELECT DISTINCT ON ( children_categories.id ) children_categories.id AS children_category_id
          FROM children_categories
          LEFT JOIN children_groups ON children_categories.id = children_groups.children_category_id
          WHERE children_groups.institution_id = #{ institution_id }
                AND
                children_groups.is_del = false
                AND
                children_groups.is_del = false
        ) bb ON dishes_products_norms.children_category_id = bb.children_category_id
        WHERE aa.enabled = true
              AND
              products.is_del = false
      SQL

    dishes_products_norms = JSON.parse( ActiveRecord::Base.connection.execute( sql )
      .to_json, symbolize_names: true )
    ###

    if children_categories.present? && dishes_products_norms.present?
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
            ( dishes_products_norms.find { | o |
              o[ :dish_id ] == md[ :dish_id ]
            } )
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
          "#{ dishes_products_norms.present? ? '' : 'Невибрано жодної страви у <Довідники -> Технологічна карта>. ' } "
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

    result = nil
    splendingdate = data[ :splendingdate ]

    if splendingdate.present?
      id = params[ :id ]
      institution_id = MenuRequirement.select( :institution_id ).find( id ).institution_id
      date_blocks = check_date_block( institution_id, splendingdate )

      if date_blocks.present?
        caption = 'Блокування документів'
        message = "Дата списання #{ date_blocks } закрита для відправлення!"
        result = { status: false, message: message, caption: caption }
      else
        status = update_base_with_id( :menu_requirements, id, data )
        result = { status: status }
      end
    end

    render json: result
  end

  def meals_dish_update #
    data = params.permit( :is_enabled ).to_h
    status = update_base_with_id( :menu_meals_dishes, params[ :id ], data )
    render json: { status: status }
  end

  def send_sap # Веб-сервис отправки плана меню-требования
    menu_requirement_id = params[ :id ]

    menu_requirement = JSON.parse( MenuRequirement
      .joins( institution: :branch )
      .select( :number,
               :splendingdate,
               :date,
               :number_sap,
               :institution_id,
               'institutions.code AS institution_code',
               'branches.code AS branch_code' )
      .find( menu_requirement_id )
    .to_json, symbolize_names: true )

    splendingdate = menu_requirement[ :splendingdate ]
    institution_id = menu_requirement[ :institution_id ]

    date_blocks = check_date_block( institution_id, splendingdate )
    if date_blocks.present?
      caption = 'Блокування документів'
      message = "Дата списання #{ date_blocks } закрита для відправлення!"
      result = { status: false, message: message, caption: caption }
    else
      sql_where_exists = <<-SQL.squish
          menu_requirements.splendingdate = '#{ splendingdate }'
          AND
          menu_requirements.institution_id = #{ institution_id }
          AND
          menu_requirements.id != #{ menu_requirement_id }
          AND
          ( ( menu_requirements.number_sap != '' AND is_del_plan_1c = false )
            OR
            ( menu_requirements.number_saf != '' AND is_del_fact_1c = false ) )
        SQL

      menu_requirement_exists = JSON.parse( MenuRequirement
        .select( :id,
                :number,
                :date,
                :number_sap,
                :date_sap,
                :number_saf,
                :date_saf )
        .where( sql_where_exists )
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
          .where.not( children_categories: { code: '000000027' } )
          .where( '( count_all_plan != 0 OR count_exemption_plan != 0 )' )
          .to_json, symbolize_names: true )

        joins_menu_products_prices = <<-SQL.squish
              LEFT JOIN menu_products_prices ON
                  menu_products_prices.product_id = menu_products.product_id
                AND
                  menu_products_prices.menu_requirement_id = menu_meals_dishes.menu_requirement_id
            SQL

        menu_products = JSON.parse( MenuMealsDish
          .joins( menu_products: [ :children_category, :product ] )
          .joins( joins_menu_products_prices )
          .select( 'SUM( menu_products.count_plan ) AS count_plan',
                  'SUM( ROUND( menu_products.count_plan * menu_products_prices.price, 5 ) ) AS amount',
                  'products.code AS product_code',
                  'children_categories.code AS category_code' )
          .where( menu_requirement_id: menu_requirement_id )
          .where( 'menu_products.count_plan != ? ', 0 )
          .where.not( children_categories: { code: '000000027' } )
          .group( 'products.code',
                  'children_categories.code' )
          .to_json, symbolize_names: true )

        if menu_children_categories.present? && menu_products.present?
          categories = menu_children_categories.map { | o |
            { 'CodeOfCategory' => o[ :code ],
              'QuantityAll' => o[ :count_all_plan ].to_s,
              'QuantityExemption' => o[ :count_exemption_plan ].to_s } }

          goods = menu_products.map { | o | {
            'CodeOfCategory' => o[ :category_code ],
            'CodeOfGoods' => o[ :product_code ],
            'Quantity' => o[ :count_plan ],
            'Amount' => o[ :amount ] } }

          message = {
            'CreateRequest' => {
              'Branch_id' => menu_requirement[ :branch_code ],
              'Institutions_id' => menu_requirement[ :institution_code ],
              'SplendingDate' => menu_requirement[ :splendingdate ],
              'Date' => menu_requirement[ :date ],
              'Goods' => goods,
              'Categories' =>  categories,
              'NumberFromWebPortal' => menu_requirement[ :number ],
              'Number1C' => menu_requirement[ :number_sap ],
              'User' => current_user[ :username ]
            }
          }

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
    end

    render json: result
  end

  def send_saf # Веб-сервис отправки факта меню-требования
    menu_requirement_id = params[ :id ]

    menu_requirement = JSON.parse( MenuRequirement
      .joins( institution: :branch )
      .select( :number,
               :splendingdate,
               :date,
               :number_saf,
               :institution_id,
               'institutions.code AS institution_code',
               'branches.code AS branch_code' )
      .find( menu_requirement_id )
      .to_json, symbolize_names: true )

    splendingdate = menu_requirement[ :splendingdate ]
    institution_id = menu_requirement[ :institution_id ]

    date_blocks = check_date_block( institution_id, splendingdate )
    if date_blocks.present?
      caption = 'Блокування документів'
      message = "Дата списання #{ date_blocks } закрита для відправлення!"
      result = { status: false, message: message, caption: caption }
    else
      menu_children_categories = JSON.parse( MenuChildrenCategory
        .joins( :children_category )
        .select( :count_all_fact, :count_exemption_fact, 'children_categories.code as code' )
        .where( menu_requirement_id: menu_requirement_id )
        .where( '( count_all_fact != 0 OR count_exemption_fact != 0 )' )
        .where.not( children_categories: { code: '000000027' } )
        .to_json, symbolize_names: true )

      joins_menu_products_prices = <<-SQL.squish
          LEFT JOIN menu_products_prices ON
              menu_products_prices.product_id = menu_products.product_id
            AND
              menu_products_prices.menu_requirement_id = menu_meals_dishes.menu_requirement_id
        SQL

      menu_products = JSON.parse( MenuMealsDish
        .joins( menu_products: [ :children_category, :product ] )
        .joins( joins_menu_products_prices )
        .select( 'SUM( menu_products.count_fact ) AS count_fact',
                'SUM( ROUND( menu_products.count_fact * menu_products_prices.price, 5 ) ) AS amount',
              'products.code AS product_code',
                'children_categories.code AS category_code' )
        .where( menu_requirement_id: menu_requirement_id )
        .where( '( menu_products.count_fact != ? OR menu_products.count_plan != ? )', 0, 0 )
        .group( 'products.code',
                'children_categories.code' )
        .to_json, symbolize_names: true )

      if menu_children_categories && menu_products
        goods = menu_products.map { | o |
          { 'CodeOfCategory' => o[ :category_code ],
            'CodeOfGoods' => o[ :product_code ],
            'Quantity' => o[ :count_fact ],
            'Amount' => o[ :amount ] }
        }

        categories = menu_children_categories.map { | o |
          { 'CodeOfCategory' => o[ :code ],
            'QuantityAll' => o[ :count_all_fact ],
            'QuantityExemption' => o[ :count_exemption_fact ] } }

        message = {
          'CreateRequest' => {
            'Branch_id' => menu_requirement[ :branch_code ],
            'Institutions_id' => menu_requirement[ :institution_code],
            'SplendingDate' => splendingdate,
            'Date' => menu_requirement[ :date ],
            'Goods' => goods,
            'Categories' => categories,
            'NumberFromWebPortal' => menu_requirement[ :number ],
            'Number1C' => menu_requirement[ :number_saf ],
            'User' => current_user[ :username ]
          }
        }

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

              sql = <<-SQL.squish
                  DELETE FROM menu_meals_dishes WHERE is_enabled = false AND menu_requirement_id = #{ menu_requirement_id };
                  DELETE FROM menu_products
                      USING menu_meals_dishes bb
                      WHERE menu_meals_dish_id = bb.id
                            AND bb.menu_requirement_id = #{ menu_requirement_id }
                            AND count_plan = 0
                            AND count_fact = 0;
                  DELETE FROM menu_products_prices WHERE
                    product_id NOT IN (
                      SELECT DISTINCT product_id
                        FROM menu_products
                        LEFT JOIN menu_meals_dishes ON
                          menu_products.menu_meals_dish_id = menu_meals_dishes.id
                        WHERE menu_meals_dishes.menu_requirement_id = menu_products_prices.menu_requirement_id
                    ) AND
                    menu_requirement_id = #{ menu_requirement_id }
                SQL

              ActiveRecord::Base.connection.execute( sql )
            end
          result = { status: true, reload: true }
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
        .where.not( children_categories: { code: '000000027' } )
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
        .where.not( children_categories: { code: '000000027' } )
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
