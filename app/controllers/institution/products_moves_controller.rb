class Institution::ProductsMovesController < Institution::BaseController

  def index ; end

  def filter # Фильтрация документов
    institution_id = current_user[ :userable_id ]
    where = <<-SQL.squish
        ( products_moves.institution_id = #{ institution_id }
          OR
          products_moves.to_institution_id = #{ institution_id } )
      SQL

    @products_moves = JSON.parse( ProductsMove
      .joins( :to_institution )
      .joins( 'LEFT JOIN date_blocks ON products_moves.date = date_blocks.date' )
      .select( :id,
               :number,
               :date,
               :number_sa,
               :date_sa,
               :is_confirmed,
               :is_del_1c,
               "NOT date_blocks.date ISNULL OR products_moves.institution_id = #{ institution_id } AS disabled",
               "products_moves.institution_id = #{ institution_id } AS is_post",
               "CASE WHEN products_moves.institution_id = #{ institution_id } THEN 'Видача' ELSE 'Прийом' END AS type_name",
               'institutions.name AS institution_name' )
      .where( date: params[ :date_start ]..params[ :date_end ] )
      .where( where )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
      .to_json, symbolize_names: true )
  end

  def delete # Удаление документа
    ProductsMove.find( params[ :id ] ).destroy
    render json: { status: true }
  end

  def create
    institution_id = current_user[ :userable_id ]
    date = Date.today
    sql = <<-SQL.squish
        WITH new_products_moves( id ) AS (
          INSERT INTO products_moves ( institution_id, date )
            VALUES ( #{ institution_id }, '#{ date }' )
            RETURNING id
            )
          INSERT INTO products_move_products
            ( products_move_id, product_id )
            SELECT new_products_moves.id,
                    products.id
              FROM new_products_moves, products
            RETURNING products_move_id
      SQL

    products_move_id = JSON.parse( ActiveRecord::Base.connection.execute( sql )
      .to_json, symbolize_names: true )[ 0 ][ :products_move_id ]

    update_prices( products_move_id, date ) # Обновление остатков і цен продуктов

    href = institution_products_moves_products_path( { id: products_move_id } )
    result = { status: true, href: href }

    render json: result
  end

  def send_sa
    products_move = JSON.parse( ProductsMove
      .joins( :to_institution )
      .select( :id,
               :number,
               :date,
               :number_sa,
               'institutions.code AS to_institution_code' )
      .find( params[ :id ] )
      .to_json( ), symbolize_names: true )

    date_blocks = check_date_block( products_move[ :date ] )
    if date_blocks.present?
      caption = 'Блокування документів'
      message = "Дата [ #{ date_blocks } ] в переміщенні закрита для відправлення!"
      result = { status: false, message: message, caption: caption }
    else
      products_move_products = JSON.parse( ProductsMoveProduct
        .joins( :product )
        .select( 'products.code AS code',
                :balance,
                :price,
                :amount,
                'ROUND( products_move_products.amount * products_move_products.price, 5 ) AS sum' )
        .where( products_move_id: products_move[ :id ] )
        .order( 'products.name' )
        .to_json( ), symbolize_names: true )
        .map { | o |
          { 'CodeOfGoods' => o[ :code ],
            'Balance' => o[ :balance ], # залишок
            'Price' => o[ :price ], # ціна
            'Amount' => o[ :amount ], # кількість
            'Sum' => o[ :sum ] # сумма
          }
        }

      message = {
        'CreateRequest' => {
          'Institutions_id' => current_institution[ :code ], # Підрозділ передавач
          'ToInstitutions_id' => products_move[ :to_institution_code ], # Підрозділ приймач
          'NumberFromWebPortal' => products_move[ :number ],
          'Date' => products_move[ :date ],
          'Products' => products_move_products,
          'Number1C' => products_move[ :number_sa ],
          'User' => current_user[ :username ]
        }
      }

      File.open( "./products_move.txt", 'w' ) { | f | f.write( message ) }
      response = { interface_state: 'OK', respond: Time.now.to_i }

      # savon_return = get_savon( :creation_time_sheet, message )
      # response = savon_return[ :response ]
      # web_service = savon_return[ :web_service ]

      if response[ :interface_state ] == 'OK'
        ProductsMove.update( products_move[ :id ],
                             date_sa: Date.today,
                             number_sa: response[ :respond ],
                             is_confirmed: false )

        result = { status: true }
      else
        result = { status: false, caption: 'Неуспішна сихронізація з ІС',
                  message: web_service.merge!( response: response ) }
      end
    end

    render json: result
  end

  def confirmed
    products_move = JSON.parse( ProductsMove
      .joins( :to_institution )
      .select( :id,
              :number,
              :date,
              :number_sa,
              'institutions.code AS to_institution_code' )
      .find( params[ :id ] )
      .to_json( ), symbolize_names: true )

    date_blocks = check_date_block( products_move[ :date ] )
    if date_blocks.present?
      caption = 'Блокування документів'
      message = "Дата [ #{ date_blocks } ] в переміщенні закрита для підтвердження!"
      result = { status: false, message: message, caption: caption }
    else
      message = {
        'CreateRequest' => {
          'Institutions_id' => current_institution[ :code ], # Підрозділ передавач
          'NumberFromWebPortal' => products_move[ :number ],
          'Number1C' => products_move[ :number_sa ],
          'User' => current_user[ :username ]
        }
      }

      File.open( "./products_move_confimed.txt", 'w' ) { | f | f.write( message ) }
      result = { status: true }

      ProductsMove.update( products_move[ :id ], is_confirmed: true )

      # savon_return = get_savon( :creation_time_sheet, message )
      # response = savon_return[ :response ]
      # web_service = savon_return[ :web_service ]

      #     if response[ :interface_state ] == 'OK'
      #       data = { date_sa: Date.today, number_sa: response[ :respond ].to_s }
      #       update_base_with_id( :timesheets, timesheet_id, data )
      #       result = { status: true }
      #     else
      #       result = { status: false, caption: 'Неуспішна сихронізація з ІС',
      #                 message: web_service.merge!( response: response ) }
      #     end
      #   else
      #     result = { status: false, caption: 'Немає данних' }
      #   end
      # end
    end

    render json: result
  end

  def products #
    institution_id = current_user[ :userable_id ]

    @products_move = JSON.parse( ProductsMove
      .select( :id,
               :number,
               :date,
               :number_sa,
               :date_sa,
               :institution_id,
               :to_institution_id,
               :is_confirmed,
               "CASE WHEN institution_id = #{ institution_id } THEN true ELSE false END AS is_post" )
      .find( params[ :id ] )
      .to_json, symbolize_names: true )

    @is_date_blocks = check_date_block( @products_move[ :date ] ).present?

    @products_move_products = JSON.parse( ProductsMoveProduct
      .joins( { product: :products_type } )
      .select( :id,
                :product_id,
                :balance,
                :price,
                :amount,
                'products.products_type_id',
                'products_types.name AS products_type_name',
                'products.name AS product_name' )
      .where( products_move_id: @products_move[ :id ] )
      .order( 'products_types.priority',
              'products_types.name',
              'products.name' )
      .to_json, symbolize_names: true )

      where_institution = @products_move[ :to_institution_id ] == institution_id ? '' :
        " id != #{ institution_id } "

      @institutions = Institution
        .select(:id, :name )
        .where( branch_id: current_institution[ :branch_id ] )
        .where( where_institution )
        .order( :name )
        .pluck( :name, :id )
  end

  def update # Обновление реквизитов документа
    data = params.permit( :date, :to_institution_id ).to_h

    result = nil
    date = data[ :date ]

    is_update = data.present?

    if date.present?
      date_blocks = check_date_block( date )

      if date_blocks.present?
        caption = 'Блокування документів'
        message = "Дата #{ date_blocks } закрита для відправлення!"
        is_update = false
        result = { status: false, message: message, caption: caption }
      end
    end

    if is_update
      status = update_base_with_id( :products_moves, params[ :id ], data )
      result = { status: status }
    end

    render json: result
  end

  def product_update # Обновление количества по продуктам
    data = params.permit( :amount ).to_h
    status = update_base_with_id( :products_move_products, params[ :id ], data )
    render json: { status: status }
  end

  def get_actual_price( date, products )
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

  def update_prices( products_move_id, date ) # Обновление остатков і цен продуктов
    products_move_products = JSON.parse( ProductsMoveProduct
      .joins( :product )
      .select( :id,
               :product_id,
               :price,
               :balance,
               'products.code',
               'products.name' )
      .where( products_move_id: products_move_id )
      .order( 'products.name' )
      .to_json, symbolize_names: true )

    return_prices = get_actual_price( date, products_move_products )

    if return_prices[ :status ]
      products_move_products_sql = ''

      actual_prices = return_prices[ :actual_prices ]
      prices_message = [ ]
      prices_data = [ ]

      products_move_products.each { | pmp |
        actual_price = actual_prices.find { | o | o[ :product ].strip == pmp[ :code ] }

        if actual_price
          price = actual_price[ :price ].to_d.truncate( 5 )
          balance = actual_price[ :quantity ].to_d.truncate( 3 )

          if price != pmp[ :price ].to_d || balance != pmp[ :balance ].to_d
            prices_message << {
              'Продукт' => pmp[ :name ],
              'Ціна' => price,
              'Залишок' => balance
            }

            prices_data << {
              product_id: pmp[ :product_id ],
              price: price,
              balance: balance
            }

            products_move_products_sql << <<-SQL.squish
                UPDATE products_move_products
                  SET price = #{ price },
                      balance =#{ balance }
                  WHERE id = #{ pmp[ :id ] } ;
              SQL
          end
        end
      }

      if prices_data.any?
        ActiveRecord::Base.connection.execute( products_move_products_sql )
        result = { status: true, caption: 'Оновлені продукти', message: prices_message, data: prices_data }
      else
        result = { status: true }
      end
    else
      result =  return_prices
    end
  end

  def prices # Обновление остатков і цен продуктов
    products_move = JSON.parse( ProductsMove
      .select( :id, :date )
      .find( params[ :id ] )
      .to_json, symbolize_names: true )

    result = update_prices( products_move[ :id ], products_move[ :date ] ) # Обновление остатков і цен продуктов

    render json: result
  end




end

