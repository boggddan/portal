class Institution::ReferenceBooksController < Institution::BaseController

  def dishes_products_norms # Вартість дітодня за меню-вимогами
    institution_id = current_user[ :userable_id ]

    sql_fields_distinct = %w(
      dishes_categories.priority
      dishes_categories.name
      dishes_products_norms.children_category_id
      dishes.priority
      dishes.name
      dishes_products.dish_id
      products_types.priority
      products_types.name
      products.name
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
      SQL

    sql_order = <<-SQL
        #{ sql_fields_distinct },
        CASE WHEN #{ sql_institution_empty } THEN 0 ELSE 1 END DESC
      SQL

    @dishes_products_norms = JSON.parse( DishesProduct
      .joins( { dishes_products_norms: :children_category },
              { dish: :dishes_category },
              { product: :products_type },
              :institution
       )
      .select(
        "DISTINCT ON( #{ sql_fields_distinct } ) dishes_products.id AS dishes_product_id",
        'dishes.dishes_category_id',
        'dishes_categories.name AS dishes_category_name',
        :dish_id,
        'dishes.name AS dish_name',
        'products.products_type_id',
        'products.name as product_name',
        'products_types.name AS products_type_name',
        :product_id,
        'dishes_products_norms.children_category_id',
        'children_categories.name AS children_category_name',
        :enabled,
        'dishes_products_norms.amount',
        'institutions.code AS institution_code'
      )
      .where( sql_where )
      .order( sql_order )
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
        products_type_name: o[ :products_type_name ]
      } }
      .keys

      File.open( "#{ $dir }dpn_dishes_products", 'w' ) { | f | f.write(  @dpn_dishes_products.to_json ) }


    # Только сгрупиррованые продкуты и блюда для html-таблицы
    @dpn_children_categories = @dishes_products_norms.group_by { | o |
      { children_category_id: o[ :children_category_id ],
        children_category_name: o[ :children_category_name ]
      } }
      .keys
  end

  def dishes_products_update # Обновление "Продукти в стравах підрозділу"
    data = params.permit( { dishes_products: [ :id, :dish_id, :product_id ] }, :enabled ).to_h
    enabled = data[ :enabled ]

    if data.present?
      sql = ''

      ids = data[ :dishes_products ].select{ | o | o [ :id ].nonzero? }.map { | o | o[ :id ] }

      sql << <<-SQL.squish if ids.any?
          UPDATE dishes_products SET
            enabled = #{ enabled }
              FROM UNNEST( ARRAY #{ ids.to_s } ) as ids
              WHERE id = ids;
        SQL

      fields = %w( institution_id dish_id product_id enabled ).join( ',' )
      dishes_products = data[ :dishes_products ]
        .select{ | o | o [ :id ].zero? }
        .map{ | o | "( #{ ( [ current_user[ :userable_id ], enabled ].insert( 1, o.slice( :dish_id, :product_id ).values ) ).join( ',' ) } )" }
        .join( ',' )

      sql << <<-SQL.squish.prepend( ' ' ) if dishes_products.present?
          INSERT INTO dishes_products ( #{ fields } )
            VALUES #{ dishes_products }
            ON CONFLICT ( institution_id, dish_id, product_id )
              DO UPDATE SET enabled = EXCLUDED.enabled ;
        SQL

      ActiveRecord::Base.connection.execute( sql ) if sql.present?
    end

    render json: { status: true }
  end

end
