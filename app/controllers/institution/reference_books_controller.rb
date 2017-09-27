class Institution::ReferenceBooksController < Institution::BaseController

  def dishes_products_norms # Вартість дітодня за меню-вимогами
    #########
    @children_categories = JSON.parse( ChildrenCategory
      .joins( :children_groups )
      .select( :id, :name )
      .where( 'children_groups.institution_id = ?', current_user[ :userable_id ] )
      .group( :id )
      .order( :priority, :name )
      .to_json, symbolize_names: true )

    products = JSON.parse( Product
      .joins( :products_type )
      .select( :id, :products_type_id,
               'products.name as product_name',
               'products_types.name as products_type_name' )
      .order( 'products_types.priority', 'products_types.name',
              'products.name' )
      .to_json, symbolize_names: true )

    dishes = JSON.parse( Dish
      .joins( :dishes_category )
      .select( :id, :dishes_category_id,
               'dishes.name as dish_name',
               'dishes_categories.name as dishes_category_name' )
      .order( 'dishes_categories.priority', 'dishes_categories.name',
              'dishes.priority', 'dishes.name')
      .to_json, symbolize_names: true )

    @dishes_products_norms = JSON.parse( DishesProductsNorm
      .joins( dishes_product: [ dish: :dishes_category, product: :products_type ],
              children_category: :children_groups )
      .select( :id,
              'dishes_categories.id AS dishes_category_id',
              'dishes_products.dish_id',
              'products.products_type_id',
              'dishes_products.product_id',
              :children_category_id,
              :amount )
      .order( 'dishes_categories.priority', 'dishes_categories.name',
              'dishes.priority', 'dishes.name',
              'products_types.priority', 'products_types.name',
              'products.name' )
      .where( 'dishes_products.institution_id = ?', current_user[ :userable_id ] )
      .where( 'children_groups.institution_id = ?', current_user[ :userable_id ] )
      .to_json, symbolize_names: true )

    # Только сгрупиррованые продкуты и блюда для html-таблицы
    @dpn_dishes_products = @dishes_products_norms.group_by { | o | { dish_id: o[ :dish_id ], product_id: o[ :product_id ] } }
      .map { | k, _ | k
      .merge!( products.select { | o |
        o[ :id ] == k[ :product_id ] }[ 0 ].slice( :product_name, :products_type_id, :products_type_name ) )
      .merge!( dishes.select { | o |
        o[ :id ] == k[ :dish_id ] }[ 0 ].slice( :dish_name, :dishes_category_id, :dishes_category_name ) )
    }

    @dishes_products = JSON.parse( DishesProduct
      .select( :id, :dish_id, :product_id, :enabled )
      .where( institution_id: current_user[ :userable_id ] )
      .to_json, symbolize_names: true )
    #########
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
