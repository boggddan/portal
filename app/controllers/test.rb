@menu_products = [{:id=>80143, :children_category_id=>2, :product_id=>207, :count_plan=>"15.0", :count_fact=>"15.0", :menu_meals_dish_id=>245, :meal_id=>1, :meal_name=>"Сніданок", :dish_id=>1, :dish_name=>"Каша", :category_name=>"1 Группа", :products_type_id=>1, :type_name=>"Вироби з молока", :product_name=>"Баклажани, кг"}, {:id=>80147, :children_category_id=>2, :product_id=>195, :count_plan=>"33.0", :count_fact=>"33.0", :menu_meals_dish_id=>245, :meal_id=>1, :meal_name=>"Сніданок", :dish_id=>1, :dish_name=>"Каша", :category_name=>"1 Группа", :products_type_id=>1, :type_name=>"Вироби з молока", :product_name=>"Горошок зелений консервований, г"}, {:id=>80197, :children_category_id=>3, :product_id=>207, :count_plan=>"7.0", :count_fact=>"12.0", :menu_meals_dish_id=>245, :meal_id=>1, :meal_name=>"Сніданок", :dish_id=>1, :dish_name=>"Каша", :category_name=>"Сад", :products_type_id=>1, :type_name=>"Вироби з молока", :product_name=>"Баклажани, кг"}, {:id=>80089, :children_category_id=>1, :product_id=>207, :count_plan=>"2.0", :count_fact=>"15.0", :menu_meals_dish_id=>245, :meal_id=>1, :meal_name=>"Сніданок", :dish_id=>1, :dish_name=>"Каша", :category_name=>"Ясли", :products_type_id=>1, :type_name=>"Вироби з молока", :product_name=>"Баклажани, кг"}]

@price_products = [{:id=>nil, :product_id=>174, :price=>"11.0"}, {:id=>nil, :product_id=>207, :price=>"30.25"}]

@products = @menu_products.group_by { | o | [ o[ :products_type_id ], o[ :product_id ] ] }
.map{ | k, v | { type_id: k[0], type_name: v[ 0 ][ :type_name ],
        id: k[ 1 ], name: v[ 0 ][ :product_name ],
        price: @price_products.select { | pp | pp[ :product_id ] == k[ 1 ] }
          .fetch( 0, { price: 0 } ).fetch( :price ) } }




  #   price: @price_products.select { | pp | pp[ :product_id ] == k[ 1 ] }
  #     .fetch( 0, { price: 0 } ).fetch( :price ) } }

@menu_products.each{ |o| puts o[:id]}
