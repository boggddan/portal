module CheckDbController
  extend ActiveSupport::Concern

  included do

    def product_code( code )
      code = code.nil? ? '' : code.strip
      if product = Product.find_by( code: code )
        product
      else
        { error: { product: "Не знайдений код продукту [#{ code }]" } }
      end
    end

    def child_code( code )
      code = code.nil? ? '' : code.strip
      if child = Child.find_by( code: code )
        child
      else
        { error: { child: "Не знайдений код дитини [#{ code }]" } }
      end
    end

    def reasons_absence_code( code )
      code = code.nil? ? '' : code.strip
      if reasons_absence = ReasonsAbsence.find_by( code: code )
        reasons_absence
      else
        { error: { reasons_absence: "Не знайдений код причини відсутності [#{ code }]" } }
      end
    end

    def children_group_code( code )
      code = code.nil? ? '' : code.strip
      if children_group = ChildrenGroup.find_by( code: code )
        children_group
      else
        { error: { children_group:  "Не знайдений код дитячої группи [#{ code }]" } }
      end
    end

    def causes_deviation_code( code )
      code = code.nil? ? '' : code.strip
      if causes_deviation = CausesDeviation.find_by( code: code )
        causes_deviation
      else
        { error: { causes_deviation: "Не знайдений код причини відхилення [#{ code }]" } }
      end
    end

    def exists_codes( table, codes )
      codes_str = codes.map { | o |
        o.class.name == 'Integer' ? o : ( o || '' ).strip
      }.to_s.gsub( '"', '\'' )

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
  end

  def update_prices_for_menu_requirement( menu_requirement ) # Обновление остатков і цен продуктов
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

    goods = menu_products_price
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

      menu_products_prices_sql = ''

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
      result = { status: false, caption: 'Неуспішна сихронізація з ІС',
                 message: web_service.merge!( response: response ) }
    end
  end
end
