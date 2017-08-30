require 'json'
require 'active_support/core_ext/hash'
require 'awesome_print'
require 'faker'


  # ###############################################################################################
  # # POST /api/cu_dishes_products_norms
  # { "dishes_products_norms":
  #   [ { "dish_code": "000000002", "product_code": "000000054", "children_category_code": "000000001", "amount": 0.01 },
  #     { "dish_code": "000000002", "product_code": "000000047", "children_category_code": "000000001", "amount": 0.05 } ]
  # }


  def exists_codes( table, codes )
    codes_str = codes.map { | o | ( o || '' ).strip }.to_s.gsub( '"', '\'' )

    sql = <<-SQL.squish
        SELECT code, COALESCE( bb.id, -1 ) as id
          FROM UNNEST( ARRAY #{ codes_str } ) AS code
          LEFT JOIN #{ table } bb USING( code )
      SQL

    obj = JSON.parse( ActiveRecord::Base.connection.execute( sql ).to_json, symbolize_names: true )
    error_codes = obj.select { | o | o[ :id ] == -1 }.map{ | o | o[ :code ] }

    { status: error_codes.empty?,
      obj: obj.map { | o | [ o[ :code ], o[ :id ] ] }.to_h,
      error: { table => "Не знайдені кода: #{ error_codes.to_s.gsub( '"', '\'' ) }" } }
  end

  def dishes_products_norms_update( params )
    errors = []

    dishes_products_norms = params[ :dishes_products_norms ]

    dishes_codes = dishes_products_norms.group_by { | o | o[ :dish_code ] }.keys
    # dishes = exists_codes( :dishes, dishes_codes )
    dishes = {:status=>true, :obj=>{"000000002"=>980190962}, :error=>{:dishes=>"Не знайдені кода: []"}}
    errors.merge!( dishes[ :error ] ) unless dishes[ :status ]

    products_codes = dishes_products_norms.group_by { | o | o[ :product_code ] }.keys
    # products = exists_codes( :products, products_codes )
    products = {:status=>true, :obj=>{"000000054"=>25, "000000047"=>19}, :error=>{:products=>"Не знайдені кода: []"}}
    errors.merge!( products[ :error ] ) unless products[ :status ]

    children_categories_codes = dishes_products_norms.group_by { | o | o[ :children_category_code ] }.keys
    # children_categories = exists_codes( :children_categories, children_categories_codes )
    children_categories = {:status=>true, :obj=>{"000000001"=>4}, :error=>{:children_categories=>"Не знайдені кода: []"}}
    errors.merge!( children_categories[ :error ] ) unless children_categories[ :status ]

    if errors.empty?
      values = [ ]

      dishes_products_norms.each_with_index do | obj, index |
        error = { dish_code: 'Не знайдений параметр [dish_code]',
          product_code: 'Не знайдений параметр [product_code]',
          children_category_code: 'Не знайдений параметр [children_category_code]',
          amount: 'Не знайдений параметр [amount]' }.except( *obj.keys )

        if error.empty?
          values << [].tap { | value |
            value << dishes[ :obj ][ ( obj[ :dish_code]  || '' ).strip ]
            value << products[ :obj ][ ( obj[ :product_code]  || '' ).strip ]
            value << children_categories[ :obj ][ ( obj[ :children_category_code]  || '' ).strip ]
            value << obj[ :amount ] || 0
          }
        else
          errors << { index: "Рядок [#{ index + 1 }]" }.merge!( error )
        end
      end

      if error.empty?
        ActiveRecord::Base.transaction do

          fields = %w( dish_id product_id children_category_id amount ).join( ',' )

sql = <<-
          sql_values = ''

          sql = "INSERT INTO timesheet_dates ( #{ fields } ) VALUES #{ sql_values[1..-1] }"

          ActiveRecord::Base.connection.execute( sql )

          href = institution_timesheets_dates_path( { id: id } )
          result = { status: true, href: href }
        end
      else
        result = { status: false, caption: 'Неможливо створити документ',
                  message: { error: error }.merge!( web_service ) }
      end
    else
      result = { status: false, caption: 'За вибраний період даних немає в ІС',
                message: web_service.merge!( response: response ) }
    end
  end
      p values
    end

# p errors



    #   ActiveRecord::Base.transaction do

    #     if error.empty?
    #       dishes_category = dishes_category_code( obj[ :dishes_category_code ].strip )


    #       unless error = dishes_category[ :error ]
    #         code = obj[ :code ].strip
    #         update_fields = { name: obj[ :name ], priority: obj[ :priority ], dishes_category: dishes_category }
    #         dish = Dish.create_with( update_fields ).find_or_create_by( code: code )
    #         dish.update( update_fields )
    #         ids << { code: code, id: dish.id }
    #       end
    #     end

    #     ( errors << { index: "Рядок [#{ index + 1 }]" }.merge!( error ) ) if error && error.any?
    #   end

    #   raise ActiveRecord::Rollback if errors.any?
    # end

    # render json: errors.any? ? { result: false, error: errors }
    #     : { result: true, dishes: ids  }
  end

  # # GET api/dish?code=000000001
  # def dish_view
  #   error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

  #   if error.size == 1
  #     error = { }
  #     dish = Dish.last
  #   else
  #     if error.empty?
  #       dish = dish_code( params[ :code ].strip )
  #       error = dish[ :error ]
  #     end
  #   end

  #   render json: dish ? dish.to_json( include: { dishes_category: { only: [ :code, :name ] } } )
  #     : { result: false, error: [ error ] }
  # end

  # # GET /api/dishes
  # def dishes_view
  #   render json: Dish.all.order( :code ).to_json( include: { dishes_category: { only: [ :code, :name ] } } )
  # end
  # ###############################################################################################


params =
{ "dishes_products_norms":
  [ { "dish_code": "000000002", "product_code": "000000054", "children_category_code": "000000001", "amount": 0.01 },
    { "dish_code": "000000002", "product_code": "000000047", "children_category_code": "000000001", "amount": 0.05 } ]
}


dishes_products_norms_update( params )
