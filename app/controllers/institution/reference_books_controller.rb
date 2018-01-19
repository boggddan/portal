class Institution::ReferenceBooksController < Institution::BaseController

  def dishes_products_norms # Вартість дітодня за меню-вимогами
    institution_id = current_user[ :userable_id ]

    sql = <<-SQL.squish
        SELECT aa.institution_dish_id,
               aa.institution_code,
               aa.dishes_category_id,
               aa.dishes_category_name,
               aa.dish_id,
               aa.dish_name,
               products.products_type_id,
               products.name AS product_name,
               products_types.name AS products_type_name,
               dishes_products.product_id,
               dishes_products_norms.children_category_id,
               bb.children_category_name,
               aa.enabled,
               dishes_products_norms.amount
        FROM (
          SELECT DISTINCT ON( dish_id ) institution_dishes.id AS institution_dish_id,
                 institutions.code AS institution_code,
                 institution_dishes.institution_id,
                 institution_dishes.dish_id,
                 institution_dishes.enabled,
                 dishes_categories.priority AS dishes_category_priority,
                 dishes.dishes_category_id,
                 dishes_categories.name AS dishes_category_name,
                 dishes_categories.name,
                 dishes.priority AS dish_priority,
                 dishes.name AS dish_name
          FROM institution_dishes
          INNER JOIN institutions ON institutions.id = institution_dishes.institution_id
          INNER JOIN dishes ON dishes.id = institution_dishes.dish_id
          INNER JOIN dishes_categories ON dishes_categories.id = dishes.dishes_category_id
          WHERE institutions.code = 0
                OR
                institution_dishes.institution_id = #{ institution_id }
          ORDER by dish_id,
                  institutions.code DESC
        ) aa
        INNER JOIN dishes_products ON aa.institution_dish_id = dishes_products.institution_dish_id
        INNER JOIN dishes_products_norms ON dishes_products.id = dishes_products_norms.dishes_product_id
        INNER JOIN (
          SELECT DISTINCT ON ( children_categories.id ) children_categories.id AS children_category_id,
                children_categories.name as children_category_name,
                children_categories.priority as children_category_priority
          FROM children_categories
          LEFT JOIN children_groups ON children_categories.id = children_groups.children_category_id
          WHERE children_groups.institution_id = #{ institution_id }
                AND
                children_groups.is_del = false
                AND
                children_categories.is_del = false
        ) bb ON dishes_products_norms.children_category_id = bb.children_category_id
        INNER JOIN products ON products.id = dishes_products.product_id
        INNER JOIN products_types ON products_types.id = products.products_type_id
        ORDER BY aa.dishes_category_priority,
                aa.dishes_category_name,
                aa.dish_priority,
                aa.dish_name,
                products_types.priority,
                products_types.name,
                products.name,
                bb.children_category_priority,
                bb.children_category_name
        SQL

    @dishes_products_norms = JSON.parse( ActiveRecord::Base.connection.execute( sql )
      .to_json, symbolize_names: true )

    # Только сгрупиррованые продкуты и блюда для html-таблицы
    @dpn_dishes_products = @dishes_products_norms.group_by { | o |
      { dish_id: o[ :dish_id ],
        dish_name: o[ :dish_name ],
        dishes_category_id: o[ :dishes_category_id ],
        dishes_category_name: o[ :dishes_category_name ],
        product_id: o[ :product_id ],
        product_name: o[ :product_name ],
        products_type_id: o[ :products_type_id ],
        products_type_name: o[ :products_type_name ],
        institution_code: o[ :institution_code ],
        institution_dish_id: o[ :institution_dish_id ],
        enabled: o[ :enabled ]
      } }
      .keys

    # Только сгрупиррованые продкуты и блюда для html-таблицы
    @dpn_children_categories = @dishes_products_norms.group_by { | o |
      { children_category_id: o[ :children_category_id ],
        children_category_name: o[ :children_category_name ]
      } }
      .keys
  end

  def dishes_products_update # Обновление "Продукти в стравах підрозділу"
    data = params.permit( :institution_dish_id, :enabled ).to_h
    InstitutionDish.where( id: data[ :institution_dish_id ] ).update_all( enabled: data[ :enabled ] ) if data.present?
    render json: { status: true }
  end

end
