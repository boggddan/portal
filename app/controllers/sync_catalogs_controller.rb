class SyncCatalogsController < ApplicationController
  # skip_before_action :verify_log_in # Отключение фильтра проверки пользователя

  def branch_code( code )
    code = code.nil? ? '' : code.strip
    if branch = Branch.find_by( code: code )
      branch
    else
      { error: { branch: "Не знайдений код відділу [#{ code }]" } }
    end
  end

  def institution_code( code )
    if institution = Institution.find_by( code: code )
      institution
    else
      { error: { institution:  "Не знайдений код підрозділу [#{ code }]" } }
    end
  end

  def supplier_code( code )
    code = code.nil? ? '' : code.strip
    if supplier = Supplier.find_by( code: code )
      supplier
    else
      { error: { supplier: "Не знайдений код постачальника [#{ code }]" } }
    end
  end

  def products_type_code( code )
    code = code.nil? ? '' : code.strip
    if products_type = ProductsType.find_by( code: code )
      products_type
    else
      { error: { products_type: "Не знайдений код типу продукту [#{ code }]" } }
    end
  end

  def children_categories_type_code( code )
    code = code.nil? ? '' : code.strip
    if children_categories_type = ChildrenCategoriesType.find_by( code: code )
      children_categories_type
    else
      { error: { children_categories_type: "Не знайдений тип категорії дітей [#{ code }]" } }
    end
  end

  def children_category_code( code )
    code = code.nil? ? '' : code.strip
    if children_category = ChildrenCategory.find_by( code: code )
      children_category
    else
      { error: { children_category: "Не знайдений код категорії дитини [#{ code }]" } }
    end
  end

  def package_code( code )
    code = code.nil? ? '' : code.strip
    if package = Package.find_by( code: code )
      package
    else
      { error: { package: "Не знайдений код упаковки [#{ code }]" } }
    end
  end

  def dishes_category_code( code )
    code = code.nil? ? '' : code.strip
    if dishes_category = DishesCategory.find_by( code: code )
      dishes_category
    else
      { error: { dishes_category: "Не знайдений код категорії страви [#{ code }]" } }
    end
  end

  def meal_code( code )
    code = code.nil? ? '' : code.strip
    if meal = Meal.find_by( code: code )
      meal
    else
      { error: { meal: "Не знайдений код страви [#{ code }]" } }
    end
  end

  def dish_code( code )
    code = code.nil? ? '' : code.strip
    if dish = Dish.find_by( code: code )
      dish
    else
      { error: { dish: "Не знайдений код страви [#{ code }]" } }
    end
  end

  def price_product_date( branch, institution, product, date )
    if price_product = PriceProduct.where( branch: branch, institution: institution, product: product )
                         .where( ' price_date <= ? ', date ).order( :price_date ).last
      price_product
    else
      { error: { price_product: "Не знайдений продукт на дату <= [#{ date }]" } }
    end
  end

  def children_day_cost_date( children_category, date )
    if children_day_cost = ChildrenDayCost.where( children_category: children_category )
                             .where( ' cost_date <= ? ', date ).order( :cost_date ).last
      children_day_cost
    else
      { error: { children_day_cost: "Не знайдена категорія на дату <= [#{ date }]" } }
    end
  end

  def suppliers_package_date( institution, supplier, product, package, period )
    if suppliers_package = SuppliersPackage
                             .find_by( institution: institution, supplier: supplier, product: product, package: package, period: period )
      suppliers_package
    else
      { error: { suppliers_package: "Не знайдена упаковка постачальника" } }
    end
  end


  def supplier_order_number( branch, number )
    number = number.nil? ? '' : number.strip
    if supplier_order = SupplierOrder.find_by( branch: branch, number: number )
      supplier_order
    else
      { error: { supplier_order: "Не знайдений номер заявки постачальникам [#{ number }]" } }
    end
  end

  def receipt_number( institution, number )
    number = number.nil? ? '' : number.strip
    if receipt = Receipt.find_by( institution: institution, number: number )
      receipt
    else
      { error: { receipt: "Не знайдений номер поставки [#{ number }]" } }
    end
  end

  def institution_order_number( institution, number )
    number = number.nil? ? '' : number.strip
    if institution_order = InstitutionOrder.find_by( institution: institution, number: number )
      institution_order
    else
      { error: { institution_order: "Не знайдена заявка [#{ number }]" } }
    end
  end

  def io_correction_number( institution_order, number )
    number = number.nil? ? '' : number.strip
    if io_correction = IoCorrection.find_by( institution_order: institution_order, number: number )
      io_correction
    else
      { error: { institution_order_correction: "Не знайдена коригувальна заявка [#{ number }]" } }
    end
  end

  def menu_requirement_number( institution, number )
    number = number.nil? ? '' : number.strip
    if menu_requirement = MenuRequirement.find_by( institution: institution, number: number )
      menu_requirement
    else
      { error: { menu_requirement: "Не знайдена меню-вимога [#{ number }]" } }
    end
  end

  def timesheet_number( institution, number )
    number = number.nil? ? '' : number.strip
    if timesheet = Timesheet.find_by( institution: institution, number: number )
      timesheet
    else
      { error: { timesheet: "Не знайдений табель [#{ number }]" } }
    end
  end

  #
  #   Обновление справочников
  #

  ###############################################################################################
  # POST /api/cu_branch { "code": "0001", "name": "Відділ освіти №1" }
  def branch_update
    error = { code: 'Не знайдений параметр [code]', name: 'Не знайдений параметр [name]' }
              .stringify_keys!.except( *params.keys )
    if error.empty?
      code = params[ :code ].strip
      update_fields = { name: params[ :name ] }
      branch = Branch.create_with( update_fields ).find_or_create_by( code: code )
      branch.update( update_fields )
    end
    render json: error.any? ? { result: false, error: [ error ] } : { result: true, code: code, id: branch.id  }
  end

  # GET /api/branch?code=0001
  def branch_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = {}
      branch = Branch.last
    else
      if error.empty?
        branch = branch_code( params[ :code ].strip )
        error = branch[ :error ]
      end
    end

    render json: branch ? branch.to_json : { result: false, error: [ error ] }
  end

  # GET /api/branches
  def branches_view
    render json: Branch.all.order( :code ).to_json
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_institution { "code": "14", "name": "18 (ДОУ)", "prefix": "Д18", "branch_code": "00000000003" }
  def institution_update
    error = { code: 'Не знайдений параметр [code]',
              name: 'Не знайдений параметр [name]',
              prefix: 'Не знайдений параметр [prefix]',
              branch_code: 'Не знайдений параметр [branch_code]' }.stringify_keys!.except( *params.keys )
    if error.empty?
      branch = branch_code( params[ :branch_code ].strip )
      unless error = branch[ :error ]
        code = params[ :code ]
        update_fields = { name: params[ :name ], prefix: params[ :prefix ], branch: branch }
        institution = Institution.create_with( update_fields ).find_or_create_by( code: code )
        institution.update( update_fields )
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
      : { result: true, code: code, id: institution.id }
  end

  # GET /api/institution?code=14
  def institution_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = {}
      institution = Institution.last
    else
      if error.empty?
        institution = institution_code( params[ :code ] )
        error = institution[ :error ]
      end
    end

    render json: institution ? institution.to_json( include: { branch: { only: [ :code, :name ] } } )
      : { result: false, error: [ error ] }
  end

  # GET /api/institutions
  def institutions_view
    render json: Institution.all.order( :code ).to_json( include: { branch: { only: [ :code, :name ] } } )
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_products_type { "code": "000000001", "name": "Вироби з молока", "priority": 1 }
  def products_type_update
    error = { code: 'Не знайдений параметр [code]',
              name: 'Не знайдений параметр [name]',
              priority: 'Не знайдений параметр [priority]' }.stringify_keys!.except( *params.keys )
    if error.empty?
      code = params[ :code ].strip
      update_fields = { name: params[ :name ], priority: params[ :priority ] }
      products_type = ProductsType.create_with( update_fields ).find_or_create_by( code: code )
      products_type.update( update_fields )
    end
    render json: error.any? ? { result: false, error: [ error ] } : { result: true, code: code, id: products_type.id  }
  end

  # GET /api/products_type?code=000000001
  def products_type_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = { }
      products_type = ProductsType.last
    else
      if error.empty?
        products_type = products_type_code( params[ :code ].strip )
        error = products_type[ :error ]
      end
    end

    render json: products_type ? products_type.to_json : { result: false, error: [ error ] }
  end

  # GET /api/products_types
  def products_types_view
    render json: ProductsType.all.order( :priority ).to_json
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_product { "code": "00000000079", "name": "Баклажани", "products_type": "000000001" }
  def product_update
    error = { code: 'Не знайдений параметр [code]',
              name: 'Не знайдений параметр [name]',
              products_type_code: 'Не знайдений параметр [products_type_code]' }.stringify_keys!.except( *params.keys )
    if error.empty?
      products_type = products_type_code( params[ :products_type_code ].strip )

      unless error = products_type[ :error ]
        code = params[ :code ].strip
        update_fields = { name: params[ :name ], products_type: products_type }
        product = Product.create_with( update_fields ).find_or_create_by( code: code )
        product.update( update_fields )
        id = product.id
      end
    end
    render json: error && error.any? ? { result: false, error: [ error ] }
      : { result: true, code: code, id: product.id }
  end

  # GET /api/product?code=000000079
  def product_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = {}
      product = Product.last
    else
      if error.empty?
        product = product_code( params[ :code ].strip )
        error = product[ :error ]
      end
    end

    render json: product ? product.to_json( include: { products_type: { only: [ :code, :name ] } } )
      : { result: false, error: [ error ] }
  end

  # GET /api/products
  def products_view
    render json: Product.all.order( :code ).to_json( include: { products_type: { only: [ :code, :name ] } } )
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_supplier { "code": "25", "name": "ТОВ Постач № 25" }
  def supplier_update
    error = { code: 'Не знайдений параметр [code]', name: 'Не знайдений параметр [name]' }
              .stringify_keys!.except( *params.keys )
    if error.empty?
      code = params[ :code ].strip
      update_fields = { name: params[ :name ] }
      Supplier.create_with( update_fields ).find_or_create_by( code: code ).update( update_fields )
    end
    render json: error.any? ? { result: false, error: [ error ]  } : { result: true, code: code }
  end

  # GET /api/supplier?code=16
  def supplier_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = {}
      supplier = Supplier.last
    else
      if error.empty?
        supplier = supplier_code( params[ :code ].strip )
        error = supplier[ :error ]
      end
    end

    render json: supplier ? supplier.to_json : { result: false, error: [ error ] }
  end

  # GET /api/suppliers
  def suppliers_view
    render json: Supplier.all.order( :code ).to_json
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_children_categories_type { "code": "00000001", "name": "Дошкільний" }
  def children_categories_type_update
    error = { code: 'Не знайдений параметр [code]', name: 'Не знайдений параметр [name]' }
              .stringify_keys!.except( *params.keys )
    if error.empty?
      code = params[ :code ].strip
      update_fields = { name: params[ :name ] }
      ChildrenCategoriesType.create_with( update_fields ).find_or_create_by( code: code ).update( update_fields )
    end
    render json: error.any? ? { result: false, error: [ error ] } : { result: true, code: code }
  end

  # GET /api/children_categories_type?code=16
  def children_categories_type_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = {}
      children_categories_type = ChildrenCategoriesType.last
    else
      if error.empty?
        children_categories_type = children_categories_type_code( params[ :code ].strip )
        error = children_categories_type[ :error ]
      end
    end

    render json: children_categories_type ? children_categories_type.to_json : { result: false, error: [ error ] }
  end

  # GET /api/children_categories_types
  def children_categories_types_view
    render json: ChildrenCategoriesType.all.order( :code ).to_json
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_children_category { "code": "000000001", "name": "Яслі", "priority": 1, "children_categories_type_code": "000000001" }
  def children_category_update
    error = { code: 'Не знайдений параметр [code]',
              name: 'Не знайдений параметр [name]',
              priority: 'Не знайдений параметр [priority]',
              children_categories_type_code: 'Не знайдений параметр [children_categories_type_code]' }
              .stringify_keys!.except( *params.keys )
    if error.empty?
      children_categories_type = children_categories_type_code( params[ :children_categories_type_code ].strip )
      unless error = children_categories_type[ :error ]
        code = params[ :code ].strip
        update_fields = { name: params[ :name ], priority: params[ :priority ],
                          children_categories_type: children_categories_type }
        ChildrenCategory.create_with( update_fields ).find_or_create_by( code: code ).update( update_fields )
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] } : { result: true, code: code }
  end

  # GET /api/children_category?code=000000003
  def children_category_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = {}
      children_category = ChildrenCategory.last
    else
      if error.empty?
        children_category = children_category_code( params[ :code ].strip )
        error = children_category[ :error ]
      end
    end

    render json: children_category ?
        children_category.to_json( include: { children_categories_type: { only: [ :code, :name ] } } )
      : { result: false, error: [ error ] }
  end

  # GET /api/children_categories
  def children_categories_view
    render json: ChildrenCategory.all.order( :code ).to_json(
      include: { children_categories_type: { only: [ :code, :name ] } } )
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_package { "code": "000000001", "name": "Сітка 5 кг", "conversion_factor": 5.000000 }
  def package_update
    error = { code: 'Не знайдений параметр [code]',
              name: 'Не знайдений параметр [name]',
              conversion_factor: 'Не знайдений параметр [conversion_factor]' }
              .stringify_keys!.except( *params.keys )
    if error.empty?
      code = params[ :code ].strip
      update_fields = { name: params[ :name ], conversion_factor: params[ :conversion_factor ] }
      package = Package.create_with( update_fields ).find_or_create_by( code: code )
      package.update( update_fields )
    end
    render json: error && error.any? ? { result: false, error: [ error ] } : { result: true, code: code, id: package.id }
  end

  # GET /api/package?code=000000001
  def package_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = { }
      package = Package.last
    else
      if error.empty?
        package = package_code( params[ :code ] )
        error = package[ :error ]
      end
    end

    render json: package ? package.to_json : { result: false, error: [ error ] }
  end

  # GET /api/packages
  def packages_view
    render json: Package.all.order( :code ).to_json
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_causes_deviation { "code": "000000002", "name": "Причина 2" }
  def causes_deviation_update
    error = { code: 'Не знайдений параметр [code]', name: 'Не знайдений параметр [name]' }
              .stringify_keys!.except( *params.keys )
    if error.empty?
      code = params[ :code ].strip
      update_fields = { name: params[ :name ] }
      causes_deviation = CausesDeviation.create_with( update_fields ).find_or_create_by( code: code )
      causes_deviation.update( update_fields )
    end
    render json: error.any? ? { result: false, error: [ error ]  } : { result: true, code: code, id: causes_deviation.id }
  end

  # GET /api/causes_deviation?code=000000002
  def causes_deviation_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = {}
      causes_deviation = CausesDeviation.last
    else
      if error.empty?
        causes_deviation = causes_deviation_code( params[ :code ].strip )
        error = causes_deviation[ :error ]
      end
    end

    render json: causes_deviation ? causes_deviation.to_json : { result: false, error: [ error ] }
  end

  # GET /api/causes_deviations
  def causes_deviations_view
    render json: CausesDeviation.all.order( :code ).to_json
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_price_product { "branch_code": "0003", "institution_code": "14", "product_code": "000000079  ", "price_date": "1485296673", "price": 30.25  }
  # def price_product_update
  #   error = { branch_code: 'Не знайдений параметр [branch_code]',
  #             institution_code: 'Не знайдений параметр [institution_code]',
  #             product_code: 'Не знайдений параметр [product_code]',
  #             price_date: 'Не знайдений параметр [price_date]',
  #             price: 'Не знайдений параметр [price]' }.stringify_keys!.except( *params.keys )
  #   if error.empty?
  #     branch = branch_code( params[ :branch_code ] )
  #     error.merge!( branch[ :error ] ) if branch[ :error ]

  #     institution = institution_code( params[ :institution_code ] )
  #     error.merge!( institution[ :error ] ) if institution[ :error ]

  #     product = product_code( params[ :product_code ] )
  #     error.merge!( product[ :error ] ) if product[ :error ]

  #     if error.empty?
  #       update_fields = {  price: params[:price] }
  #       PriceProduct.create_with( update_fields ).find_or_create_by( branch: branch,
  #         institution: institution, product: product, price_date: date_int_to_str( params[ :price_date ] ) )
  #         .update( update_fields )
  #     end
  #   end

  #   render json: error.any? ? { result: false, error: [ error ] } : { result: true }
  # end

  # # GET /api/price_product?branch_code=0003&institution_code=14&product_code=000000079&price_date=2017-01-25
  # def price_product_view
  #   error = { branch_code: 'Не знайдений параметр [branch_code]',
  #             institution_code: 'Не знайдений параметр [institution_code]',
  #             product_code: 'Не знайдений параметр [product_code]',
  #             price_date: 'Не знайдений параметр [price_date]' }.stringify_keys!.except( *params.keys )

  #   if error.size == 4
  #     error = {}
  #     price_product = PriceProduct.last
  #   else
  #     if error.empty?
  #       branch = branch_code( params[ :branch_code ].strip )
  #       error.merge!( branch[ :error ] ) if branch[ :error ]

  #       institution = institution_code( params[ :institution_code ] )
  #       error.merge!( institution[ :error ] ) if institution[ :error ]

  #       product = product_code( params[ :product_code ].strip )
  #       error.merge!( product[ :error ] ) if product[ :error ]

  #       if error.empty?
  #         price_product = price_product_date( branch, institution, product, params[ :price_date ] )
  #         error = price_product[ :error ]
  #       end
  #     end
  #   end

  #   render json: price_product ? price_product.to_json( include: {
  #       branch: { only: [ :code, :name ] }, institution: { only: [ :code, :name ] }, product: { only: [ :code, :name ] } } )
  #     : { result: false, error: [error] }
  # end

  # # GET /api/price_products
  # def price_products_view
  #   render json: PriceProduct.all.order( :price_date ).to_json(
  #     include: { branch: { only: [ :code, :name ] }, institution: { only: [ :code, :name ] },
  #                product: { only: [ :code, :name ] } } )
  # end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_children_day_cost { "children_category_code": "000000001", "cost_date": "1485296673", "cost": 12.25 }
  def children_day_cost_update
    error = { children_category_code: 'Не знайдений параметр [children_category]',
              cost_date: 'Не знайдений параметр [cost_date]',
              cost: 'Не знайдений параметр [cost]' }.stringify_keys!.except( *params.keys )
    if error.empty?
      children_category = children_category_code( params[ :children_category_code ].strip )

      ChildrenDayCost.create_with( cost: params[ :cost ] ).
        find_or_create_by( children_category: children_category, cost_date: date_int_to_str( params[ :cost_date ] ) ).
        update( cost: params[ :cost ] ) if error.empty?
    end

    render json: error.any? ? { result: false, error: [ error ] } : { result: true }
  end

  # GET /children_day_cost?children_category_code=000000001&cost_date=2017-01-25
  def children_day_cost_view
    error = { children_category_code: 'Не знайдений параметр [children_category]',
              cost_date: 'Не знайдений параметр [cost_date]'}.stringify_keys!.except( *params.keys )

    if error.size == 2
      error = {}
      children_day_cost = ChildrenDayCost.last
    else
      if error.empty?
        children_category = children_category_code( params[ :children_category_code ].strip )

        unless error = children_category[ :error ]
          children_day_cost = children_day_cost_date( children_category, params[ :cost_date ] )
          error = children_day_cost[ :error ]
        end
      end
    end

    render json: children_day_cost ?
        children_day_cost.to_json( include: { children_category: { only: [ :code, :name ] } } )
      :  { result: false, error: [ error ] }
  end

  # GET api/children_day_costs
  def children_day_costs_view
    render json: ChildrenDayCost.all.order( :cost_date ).to_json(
      include: { children_category: { only: [ :code, :name ] } } )
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_child { "code": "000000001", "name": "Гітлер Адольф Алозойович" }
  def child_update
    error = { code: 'Не знайдений параметр [code]', name: 'Не знайдений параметр [name]' }
              .stringify_keys!.except( *params.keys )
    if error.empty?
      code = params[ :code ].strip
      update_fields = { name: params[ :name ] }
      Child.create_with( update_fields ).find_or_create_by( code: code ).update( update_fields )
    end

    render json: error.any? ? { result: false, error: [ error ] } : { result: true, code: code }
  end

  # GET /api/child?code=000000001
  def child_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = {}
      branch = Child.last
    else
      if error.empty?
        child = child_code( params[ :code ].strip )
        error = child[ :error ]
      end
    end

    render json: child ? child.to_json : { result: false, error: [ error ] }
  end

  # GET /api/children
  def children_view
    render json: Child.all.order( :code ).to_json
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_suppliers_package { "institution_code": "14", "supplier_code": "8", "product_code": "00000000079",
  #                               "package_code": "000000001", "period": "1496448000", "activity": 1 }
  def suppliers_package_update
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              supplier_code: 'Не знайдений параметр [supplier_code]',
              product_code: 'Не знайдений параметр [product_code]',
              package_code: 'Не знайдений параметр [package_code]',
              period: 'Не знайдений параметр [period]',
              activity: 'Не знайдений параметр [activity]' }.stringify_keys!.except( *params.keys )
    if error.empty?
      institution = institution_code( params[ :institution_code ] )
      error.merge!( institution[ :error ] ) if institution[ :error ]

      supplier = supplier_code( params[ :supplier_code ] )
      error.merge!( supplier[ :error ] ) if supplier[ :error ]

      product = product_code( params[ :product_code ] )
      error.merge!( product[ :error ] ) if product[ :error ]

      package = package_code( params[ :package_code ] )
      error.merge!( package[ :error ] ) if package[ :error ]

      if error.empty?
        update_fields = { activity: params[ :activity ] }
        suppliers_package = SuppliersPackage.create_with( update_fields )
                              .find_or_create_by( institution: institution, supplier: supplier, product: product, package: package,
                                                  period: date_int_to_str( params[ :period ] ) )
        suppliers_package.update( update_fields )
      end
    end

    render json: error.any? ? { result: false, error: [ error ] }
      : { result: true, id: suppliers_package.id }
  end

  # GET /api/suppliers_package?institution_code=14&supplier_code=8&product_code=00000000079&package_code=000000001&period=2017-05-03
  def suppliers_package_view
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              supplier_code: 'Не знайдений параметр [supplier_code]',
              product_code: 'Не знайдений параметр [product_code]',
              package_code: 'Не знайдений параметр [package_code]',
              period: 'Не знайдений параметр [period]' }.stringify_keys!.except( *params.keys )

    if error.size == 5
      error = { }
      suppliers_package = SuppliersPackage.last
    else
      if error.empty?
        institution = institution_code( params[ :institution_code ] )
        error.merge!( institution[ :error ] ) if institution[ :error ]

        supplier = supplier_code( params[ :supplier_code ] )
        error.merge!( supplier[ :error ] ) if supplier[ :error ]

        product = product_code( params[ :product_code ] )
        error.merge!( product[ :error ] ) if product[ :error ]

        package = package_code( params[ :package_code ] )
        error.merge!( package[ :error ] ) if package[ :error ]

        if error.empty?
          suppliers_package = suppliers_package_date( institution, supplier, product, package, params[ :period ] )
          error = suppliers_package[ :error ]
        end
      end
    end

    render json: suppliers_package ?
      suppliers_package.to_json( include: {
        institution: { only: [ :code, :name ] },
        supplier: { only: [ :code, :name ] },
        product: { only: [ :code, :name ] },
        package: { only: [ :code, :name ] } } )
    : { result: false, error: [error] }
  end

  # GET /api/suppliers_packages
  def suppliers_packages_view
    render json: SuppliersPackage.all.order( :period ).to_json( include: {
      institution: { only: [ :code, :name ] },
      supplier: { only: [ :code, :name ] },
      product: { only: [ :code, :name ] },
      package: { only: [ :code, :name ] } } )
  end

  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_reasons_absence { "code": "000000001", "mark": "Х", "name": "Хвороба" }
  def reasons_absence_update
    error = { code: 'Не знайдений параметр [code]', mark: 'Не знайдений параметр [mark]',
              name: 'Не знайдений параметр [name]' }.stringify_keys!.except( *params.keys )
    if error.empty?
      code = params[ :code ].strip
      update_fields = { mark: params[ :mark ], name: params[ :name ] }
      ReasonsAbsence.create_with( update_fields ).find_or_create_by( code: code ).update( update_fields )
    end
    render json: error.any? ? { result: false, error: [ error ] } : { result: true, code: code }
  end

  # GET /api/reasons_absence?code=000000001
  def reasons_absence_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = {}
      reasons_absence = ReasonsAbsence.last
    else
      if error.empty?
        reasons_absence = reasons_absence_code( params[ :code ].strip )
        error = reasons_absence[ :error ]
      end
    end

    render json: reasons_absence ? reasons_absence.to_json : { result: false, error: [ error ] }
  end

  # GET /api/reasons_absences
  def reasons_absences_view
    render json: ReasonsAbsence.all.order( :code ).to_json
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_children_group { "code": "000000003", "name": "3\1", "children_category_code": "000000001", "institution_code": "14"}
  def children_group_update
    error = { code: 'Не знайдений параметр [code]',
              name: 'Не знайдений параметр [name]',
              children_category_code: 'Не знайдений параметр [children_category_code]',
              institution_code: 'Не знайдений параметр [institution_code]'}.stringify_keys!.except( *params.keys )

    if error.empty?
      children_category = children_category_code( params[ :children_category_code ].strip )
      error.merge!( children_category[ :error ] ) if children_category[ :error ]

      institution = institution_code( params[ :institution_code ] )
      error.merge!( institution[ :error ] ) if institution[ :error ]

      if error.empty?
        code = params[ :code ].strip
        update_fields = { code: code, name: params[ :name ], children_category: children_category,
          institution: institution }
        ChildrenGroup.create_with( update_fields ).find_or_create_by( code: code ).update( update_fields )
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] } : { result: true, code: code }
  end

  # GET /api/children_group?code=000000001
  def children_group_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = {}
      children_group = ChildrenGroup.last
    else
      if error.empty?
        children_group = children_group_code( params[ :code ].strip )
        error = children_group[ :error ]
      end
    end

    render json: children_group ?
      children_group.to_json( include: { children_category: { only: [ :code, :name ] }, institution: { only: [ :code, :name ] } } )
      : { result: false, error: [ error ] }
  end

  # GET /api/children_groups
  def children_groups_view
    render json: ChildrenGroup.all.order( :code ).to_json( include: { children_category: { only: [ :code, :name ] }, institution: { only: [ :code, :name ] } } )
  end
  ###############################################################################################

  ###############################################################################################

  #
  #   Обновление документов
  #

  ###############################################################################################
  # POST /api/cu_supplier_order
  # { "branch_code": "00000000007", "supplier_code": "00000000023", "number": "ІС000000001", "number_manual": "РР000000001", "date": 1504001724, "date_start": 1498867200, "date_end": 1519862400, "products": [ { "institution_code": "14", "product_code": "000000079", "contract_number": "BX-0000001", "date": 1495542284, "count": 12, "price": 10.05}, {"institution_code": "14", "product_code": "000000046  ", "contract_number": "BX-0000001", "date": 1495628684, "count": 15, "price": 17.12 } ] }
  def supplier_order_update
    error = { branch_code: 'Не знайдений параметр [branch_code]',
              supplier_code: 'Не знайдений параметр [supplier_code]',
              number: 'Не знайдений параметр [number]',
              date: 'Не знайдений параметр [date]',
              date_start: 'Не знайдений параметр [date_start]',
              date_end: 'Не знайдений параметр [date_end]',
              products: 'Не знайдений параметр [products]' }.stringify_keys!.except( *params.keys )
    number = params[ :number ].strip
    id = 0
    if error.empty?
      supplier = supplier_code( params[ :supplier_code ].strip )
      error.merge!( supplier[ :error ] ) if supplier[ :error ]

      branch = branch_code( params[ :branch_code ].strip )
      error.merge!( branch[ :error ] ) if branch[ :error ]

      if error.empty?
        ActiveRecord::Base.transaction do
          update_fields = { supplier: supplier,
                            is_del_1c: false,
                            date: date_int_to_str( params[ :date ] ),
                            date_start: date_int_to_str( params[ :date_start ] ),
                            date_end: date_int_to_str( params[ :date_end ] ) }

          if supplier_order = branch.supplier_orders.find_by( number: number )
            supplier_order.update( update_fields )
          else
            supplier_order = SupplierOrder.create_with( update_fields )
              .create( branch: branch, supplier: supplier, number: number )
          end

          id = supplier_order.id

          supplier_order_products = supplier_order.supplier_order_products
          supplier_order_products.update_all( count: 0 )

          error_products = []
          params[ :products ].each_with_index do | product_par, index |
            error = { institution_code: 'Не знайдений параметр [institution_code]',
                      product_code: 'Не знайдений параметр [product_code]',
                      contract_number: 'Не знайдений параметр [contract_number]',
                      contract_number_manual: 'Не знайдений параметр [contract_number_manual]',
                      date: 'Не знайдений параметр [date]',
                      count: 'Не знайдений параметр [count]',
                      price: 'Не знайдений параметр [price]' }.stringify_keys!.except( *product_par.keys )

            if error.empty?
              institution = institution_code( product_par[ :institution_code ] )
              error.merge!( institution[ :error ] ) if institution[ :error ]

              product = product_code( product_par[ :product_code ].strip )
              error.merge!( product[ :error ] ) if product[ :error ]

              if error.empty?
                supplier_order_products.create_with( count: product_par[ :count ] )
                  .find_or_create_by( institution: institution, product: product,
                                      contract_number: product_par[ :contract_number ].strip,
                                      contract_number_manual: product_par[ :contract_number_manual ].strip,
                                      date: date_int_to_str( product_par[ :date ] ) )
                  .update( count: product_par[ :count ], price: product_par[ :price ] )
              end
            end

            ( error_products << { index: "Рядок [#{ index + 1 }]" }.merge!( error ) ) if error && error.any?
          end

          if error_products.any?
            error =  { products: error_products }
            raise ActiveRecord::Rollback
          else
            supplier_order_products.where( count: 0 ).delete_all
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
      : { result: true, number: number, id: id }
  end

  # GET api/supplier_order?branch_code=0003&number=00000011
  def supplier_order_view
    error = { branch_code: 'Не знайдений параметр [branch_code]',
              number: 'Не знайдений параметр [number]' }.stringify_keys!.except( *params.keys )

    if error.size == 2
      error = {}
      supplier_order = SupplierOrder.last
    else
      if error.empty?
        branch = branch_code( params[ :branch_code ].strip )

        unless error = branch[ :error ]
          supplier_order = supplier_order_number( branch, params[ :number ].strip )
          error = supplier_order[ :error ]
        end
      end
    end

    render json: supplier_order ? supplier_order.to_json( include: { branch: { only: [ :code, :name ] },
        supplier: { only: [ :code, :name ] },
        supplier_order_products: { include: { institution: { only: [ :code, :name ] },
                                            product: { only: [:code, :name ] } } } } )
      : { result: false, error: [ error ] }
  end

  # DELETE api/supplier_order { "branch_code": "00000000003", "number": "000000000006", "type": 1 }
  def supplier_order_delete
    error = { branch_code: 'Не знайдений параметр [branch_code]',
              type: 'Не знайдений параметр [type]',
              number: 'Не знайдений параметр [number]' }.stringify_keys!.except( *params.keys )

      if error.empty?
        branch = branch_code( params[ :branch_code ].strip )

        unless error = branch[ :error ]
          number = params[ :number ]
          supplier_order = supplier_order_number( branch, number )
          unless error = supplier_order[ :error ]
            type = params[ :type ]
            case type
            when 0 then supplier_order.destroy
            when 1 then supplier_order.update( is_del_1c: true )
            else
              error = { type: "Такого значення не існує [#{ type }]" }
            end
          end
        end
      end

    render json: error && error.any? ? { result: false, error: [ error ] }
                     : { result: true, number: number, id: supplier_order.id }
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_receipt
  # { "institution_code": "14", "supplier_order_number": "000000000002", "contract_number": "Ис-000000001", "number": "0000000000011", "invoice_number": "00000012", "date": "1485296673", "date_sa": "1485296673", "number_sa": "000000000001",
  #   "products": [{"product_code": "000000079", "date": "1504224000", "count": 25, "count_invoice": 25, "causes_deviation_code": ""},
  #                {"product_code": "000000046", "date": "1504224000", "count": 19, "count_invoice": 30, "causes_deviation_code": "000000002"}]
  # }
  def receipt_update
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              supplier_order_number: 'Не знайдений параметр [supplier_order_number]',
              contract_number: 'Не знайдений параметр [contract_number]',
              number: 'Не знайдений параметр [number]',
              invoice_number: 'Не знайдений параметр [invoice_number]',
              date: 'Не знайдений параметр [date]',
              date_sa: 'Не знайдений параметр [date_sa]',
              number_sa: 'Не знайдений параметр [number_sa]',
              products: 'Не знайдений параметр [products]' }.stringify_keys!.except( *params.keys )
    number = params[ :number ].strip
    id = 0
    if error.empty?
      institution = institution_code( params[ :institution_code ] )

      unless error = institution[ :error ]
        supplier_order = supplier_order_number( institution.branch, params[ :supplier_order_number ].strip )

        unless error = supplier_order[ :error ]
          ActiveRecord::Base.transaction do
            contract_number = params[ :contract_number ].strip
            update_fields = { invoice_number: params[ :invoice_number ].strip,
                              is_del_1c: false,
                              date: date_int_to_str( params[ :date ] ),
                              date_sa: date_int_to_str( params[ :date_sa ] ),
                              number_sa: params[ :number_sa ] }
            if receipt = supplier_order.receipts.find_by( institution: institution,
                 contract_number: contract_number, number: number )
              receipt.update( update_fields )
            else
              receipt = Receipt.create_with( update_fields ).create( supplier_order: supplier_order,
                institution: institution, contract_number: contract_number )
              number = receipt.number
            end

            id = receipt.id
            receipt_products = receipt.receipt_products
            receipt_products.update_all( count: 0 )

            error_products = []
            params[ :products ].each_with_index do | product_par, index |
              error = { product_code: 'Не знайдений параметр [product_code]',
                        date: 'Не знайдений параметр [date]',
                        count: 'Не знайдений параметр [count]',
                        count_invoice: 'Не знайдений параметр [count_invoice]',
                        causes_deviation_code: 'Не знайдений параметр [causes_deviation_code]' }
                .stringify_keys!.except( *product_par.keys )

              if error.empty?
                product = product_code( product_par[ :product_code ].strip )
                error.merge!( product[ :error ] ) if product[ :error ]

                causes_deviation = causes_deviation_code( product_par[ :causes_deviation_code ].strip )
                error.merge!( causes_deviation[ :error ] ) if causes_deviation[ :error ]

                if error.empty?
                  update_fields = { count: product_par[ :count ], count_invoice: product_par[ :count_invoice ],
                                    causes_deviation: causes_deviation }
                  receipt_products.create_with( update_fields )
                    .find_or_create_by( date: date_int_to_str( product_par[ :date ] ), product: product )
                    .update( update_fields )
                end
              end

              ( error_products << { index: "Рядок [#{ index + 1 }]" }.merge!( error ) ) if error && error.any?
            end

            if error_products.any?
              error =  { products: error_products }
              raise ActiveRecord::Rollback
            else
              receipt_products.where( count: 0 ).delete_all
            end
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
      : { result: true, number: number, id: id }
  end

  # GET /api/receipt?/receipt?institution_code=14&number=KL-000000005
  def receipt_view
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              number: 'Не знайдений параметр [number]' }.stringify_keys!.except( *params.keys )

    if error.size == 2
      error = {}
      receipt = Receipt.last
    else
      if error.empty?
        institution = institution_code( params[ :institution_code ] )

        unless error = institution[ :error ]
          receipt = receipt_number( institution, params[ :number ] )
          error = receipt[ :error ]
        end
      end
    end

    render json: receipt ? receipt.to_json( include: { supplier_order: { only: [:number, :date], include: {
        branch: { only: [ :code, :name ] }, supplier: { only: [ :code, :name ] } } },
        institution: { only: [ :code, :name ] },
        receipt_products: { include: { product: { only: [ :code, :name ] },
                                       causes_deviation: { only: [ :code, :name ] } } } } )
      : { result: false, error: [ error ] }
  end

  # DELETE /api/receipt { "branch_code": "00000000003", "number": "000000000006", "type": 1 }
  def receipt_delete
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              type: 'Не знайдений параметр [type]',
              number: 'Не знайдений параметр [number]' }.stringify_keys!.except( *params.keys )

    if error.empty?
      institution = institution_code( params[ :institution_code ] )

      unless error = institution[ :error ]
        number = params[ :number ]
        receipt = receipt_number( institution, params[ :number ] )
        unless error = receipt[ :error ]
            type = params[ :type ]
            case type
            when 0 then receipt.destroy
            when 1 then receipt.update( is_del_1c: true )
            else
              error = { type: "Такого значення не існує [#{ type }]" }
            end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
                     : { result: true, number: number, id: receipt.id }
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_institution_order
  #  { "institution_code": "14", "number": "000000000002", "date": "1485296673", "date_start": "1485296673", "date_end": "1485296673", "date_sa": "1485296673", "number_sa": "000000000001",
  #    "products": [{"date": "1485296673", "product_code": "000000055", "count": 15, "description": "1 тиждень"},
  #                 {"date": "1485296673", "product_code": "000000048", "count": 15, "description": "1 тиждень,3 тиждень"}]
  #  }
  def institution_order_update
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              number: 'Не знайдений параметр [number]',
              date: 'Не знайдений параметр [date]',
              date_start: 'Не знайдений параметр [date_start]',
              date_end: 'Не знайдений параметр [date_end]',
              date_sa: 'Не знайдений параметр [date_sa]',
              number_sa: 'Не знайдений параметр [number_sa]',
              products: 'Не знайдений параметр [products]' }.stringify_keys!.except( *params.keys )
    number = params[ :number ].strip
    id = 0
    if error.empty?
      institution = institution_code( params[ :institution_code ] )

      unless error = institution[ :error ]
        ActiveRecord::Base.transaction do
          update_fields = { date: date_int_to_str( params[ :date ] ),
                            is_del_1c: false,
                            date_start: date_int_to_str( params[ :date_start ] ),
                            date_end: date_int_to_str( params[ :date_end ] ),
                            date_sa: date_int_to_str( params[ :date_sa ] ),
                            number_sa: params[ :number_sa ] }

          if institution_order = institution.institution_orders.find_by( number: number )
            institution_order.update( update_fields )
          else
            institution_order = InstitutionOrder.create_with( update_fields ).create( institution: institution )
            number = institution_order.number
          end

          id = institution_order.id

          institution_order_products = institution_order.institution_order_products
          institution_order_products.update_all( amount: 0 )

          error_products = []
          params[ :products ].each_with_index do | product_par, index |
            error = { date: 'Не знайдений параметр [date]',
                      product_code: 'Не знайдений параметр [product_code]',
                      count: 'Не знайдений параметр [count]',
                      description: 'Не знайдений параметр [description]'}.stringify_keys!.except( *product_par.keys )

            if error.empty?
              product = product_code( product_par[ :product_code ].strip )

              unless error = product[ :error ]
                update_fields = { amount: product_par[ :count ], description: product_par[ :description ] }
                institution_order_products.create_with( update_fields )
                  .find_or_create_by( date: date_int_to_str( product_par[ :date ] ), product: product )
                  .update( update_fields )
              end
            end

            ( error_products << { index: "Рядок [#{ index + 1 }]" }.merge!( error ) ) if error && error.any?
          end

          if error_products.any?
            error =  { products: error_products }
            raise ActiveRecord::Rollback
          else
            institution_order_products.where( amount: 0 ).delete_all
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
      : { result: true, number: number, id: id }
  end

  # GET api/institution_order?institution_code=14&number=000000000005
  def institution_order_view
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              number: 'Не знайдений параметр [number]' }.stringify_keys!.except( *params.keys )

    if error.size == 2
      error = {}
      institution_order = InstitutionOrder.last
    else

      if error.empty?
        institution = institution_code( params[ :institution_code ] )

        unless error = institution[ :error ]
          institution_order = institution_order_number( institution, params[ :number ].strip )
          error = institution_order[ :error ]
        end
      end
    end

    render json: institution_order ? institution_order.to_json( include: { institution: { only: [ :code, :name ] },
        institution_order_products: { include: { product: { only: [ :code, :name ] } } } } )
      : { result: false, error: [ error ] }
  end

  # DELETE api/institution_order { "institution_code": "14", "number": "KL-000000013", "type": 1 }
  def institution_order_delete
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              type: 'Не знайдений параметр [type]',
              number: 'Не знайдений параметр [number]' }.stringify_keys!.except( *params.keys )

    if error.empty?
      institution = institution_code( params[ :institution_code ] )

      unless error = institution[ :error ]
        number = params[ :number ]
        institution_order = institution_order_number( institution, number )
        unless error = institution_order[ :error ]
          type = params[ :type ]
          case type
          when 0 then institution_order.destroy
          when 1 then institution_order.update( is_del_1c: true )
          else
            error = { type: "Такого значення не існує [#{ type }]" }
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
                     : { result: true, number: number, id: institution_order.id }
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_institution_order_correction
  # { "institution_code": "14", "institution_order_number": "KL-000000058", "number": "000000000004", "date": "1485296673", "date_sa": "1485296673", "number_sa": "000000000001",
  #  "products": [{"date": "1485296673", "product_code": "000000079  ", "amount_order": 5, "amount": 7, "description": "1 тиждень"},
  #               {"date": "1485296673", "product_code": "000000048  ", "amount_order": 8, "amount": 8, "description": "1 тиждень,3 тиждень"}]
  # }
  def io_correction_update
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              institution_order_number: 'Не знайдений параметр [institution_order_number]',
              number: 'Не знайдений параметр [number]',
              date: 'Не знайдений параметр [date]',
              date_sa: 'Не знайдений параметр [date_sa]',
              number_sa: 'Не знайдений параметр [number_sa]',
              products: 'Не знайдений параметр [products]' }.stringify_keys!.except( *params.keys )
    number = params[:number].strip
    id = 0
    if error.empty?
      institution = institution_code( params[ :institution_code ] )

      unless error = institution[ :error ]
        institution_order = institution_order_number( institution, params[ :institution_order_number ].strip )

        unless error = institution_order[ :error ]
          ActiveRecord::Base.transaction do
            update_fields = { date: date_int_to_str( params[ :date ] ),
                              is_del_1c: false,
                              date_sa: date_int_to_str(params[ :date_sa ] ),
                              number_sa: params[ :number_sa ] }

            if io_correction = institution_order.io_corrections.find_by( number: number )
              io_correction.update( update_fields )
            else
              io_correction = IoCorrection.create_with( update_fields ).create( institution_order: institution_order )
              number = io_correction.number
            end

            id = io_correction.id
            io_correction_products = io_correction.io_correction_products
            io_correction_products.update_all( amount: 0, amount_order: 0 )

            error_products = []
            params[ :products ].each_with_index do | product_par, index |
              error = { date: 'Не знайдений параметр [date]',
                        product_code: 'Не знайдений параметр [product_code]',
                        amount_order: 'Не знайдений параметр [amount_order]',
                        amount: 'Не знайдений параметр [amount]',
                        description: 'Не знайдений параметр [description]' }.stringify_keys!.except( *product_par.keys )

              if error.empty?
                product = product_code( product_par[ :product_code ].strip )

                unless error = product[ :error ]
                  update_fields = { amount: product_par[ :amount ],
                                    amount_order: product_par[ :amount_order ],
                                    description: product_par[ :description ] }
                  io_correction_products.create_with( update_fields )
                    .find_or_create_by( date: date_int_to_str( product_par[ :date ] ), product: product )
                    .update( update_fields )
                end
              end

              ( error_products << { index: "Рядок [#{ index + 1 }]" }.merge!( error ) ) if error && error.any?
            end

            if error_products.any?
              error =  { products: error_products }
              raise ActiveRecord::Rollback
            else
              io_correction_products.where( amount_order: 0, amount: 0 ).delete_all
            end
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
      : { result: true, number: number, id: id }
  end

  # GET /api/institution_order_correction?institution_code=14&institution_order_number=000000000002&number=000000000010
  def io_correction_view
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              institution_order_number: 'Не знайдений параметр [institution_order_number]',
              number: 'Не знайдений параметр [number]' }.stringify_keys!.except( *params.keys )

    if error.size == 3
      error = {}
      io_correction = IoCorrection.last
    else
      if error.empty?
        institution = institution_code( params[ :institution_code ] )

        unless error = institution[ :error ]
          institution_order = institution_order_number( institution, params[ :institution_order_number ].strip )

          unless error = institution_order[ :error ]
            io_correction = io_correction_number( institution_order, params[ :number ].strip )
            error = io_correction[ :error ]
          end
        end
      end
    end

    render json: io_correction ? io_correction.to_json( include: { institution_order: { only: [ :number, :date ] },
        io_correction_products: { include: { product: { only: [ :code, :name ] } } } } )
      : { result: false, error: [ error ] }
  end

  # DELETE /api/institution_order_correction { "institution_code": "14", "institution_order_number": "KL-000000053", "number": "KL-000000022",  "type": 1 }
  def io_correction_delete
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              institution_order_number: 'Не знайдений параметр [institution_order_number]',
              type: 'Не знайдений параметр [type]',
              number: 'Не знайдений параметр [number]' }.stringify_keys!.except( *params.keys )

    if error.empty?
      institution = institution_code( params[ :institution_code ] )

      unless error = institution[ :error ]
        institution_order = institution_order_number( institution, params[ :institution_order_number ].strip )

        unless error = institution_order[ :error ]
          number = params[ :number ]
          io_correction = io_correction_number( institution_order, number )
          unless error = io_correction[ :error ]
            type = params[




            :type ]
            case type
            when 0 then io_correction.destroy
            when 1 then io_correction.update( is_del_1c: true )
            else
              error = { type: "Такого значення не існує [#{ type }]" }
            end
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
                     : { result: true, number: number, id: io_correction.id }
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_menu_requirement_plan
  #  { "branch_code": "0003", "institution_code": "14", "number": "000000000002", "date": "1485296673", "splendingdate": "1485296673", "date_sap": "1485296673", "number_sap": "000000000001",
  #    "children_categories": [{ "children_category_code": "000000001", "count_all_plan": 55, "count_exemption_plan": 19 },
  #                            { "children_category_code": "000000002", "count_all_plan": 3, "count_exemption_plan": 7 }],
  #    "products": [{"children_category_code": "000000001", "product_code": "000000079  ", "count_plan": 15 },
  #                 {"children_category_code": "000000002", "product_code": "000000079  ", "count_plan": 21 }]
  #  }
  def menu_requirement_plan_update
    error = { branch_code: 'Не знайдений параметр [branch_code]',
              institution_code: 'Не знайдений параметр [institution_code]',
              number: 'Не знайдений параметр [number]',
              date: 'Не знайдений параметр [date]',
              splendingdate: 'Не знайдений параметр [splendingdate]',
              date_sap: 'Не знайдений параметр [date_sap]',
              number_sap: 'Не знайдений параметр [number_sap]',
              children_categories: 'Не знайдений параметр [children_categories]',
              products: 'Не знайдений параметр [products]' }.stringify_keys!.except( *params.keys )
    number = params[ :number ].strip
    id = 0
    if error.empty?
      branch = branch_code( params[ :branch_code ].strip )
      error.merge!( branch[ :error ] ) if branch[ :error ]

      institution = institution_code( params[ :institution_code ] )
      error.merge!( institution[ :error ] ) if institution[ :error ]

      if error.empty?
        ActiveRecord::Base.transaction do
          date = date_int_to_str( params[ :date ] )
          splendingdate = params[ :splendingdate ].empty? ? date : date_int_to_str( params[ :splendingdate ] )
          update_fields = { date: date, branch: branch,
                            is_del_plan_1c: false,
                            splendingdate: splendingdate,
                            date_sap: date_int_to_str( params[ :date_sap ] ),
                            number_sap: params[ :number_sap ] }

          if menu_requirement = institution.menu_requirements.find_by( number: number )
            menu_requirement.update( update_fields )
          else
            menu_requirement = MenuRequirement.create_with( update_fields ).create( institution: institution )
            number = menu_requirement.number
          end

          id = menu_requirement.id

          ### menu_children_categories
          menu_children_categories = menu_requirement.menu_children_categories
          menu_children_categories.update_all( count_all_plan: 0, count_exemption_plan: 0, count_all_fact: 0,
                                               count_exemption_fact: 0 )

          #################################
          # Создание запроса для блюд

          sql_delete = "DELETE FROM menu_meals_dishes WHERE menu_requirement_id = #{ id };"

          meals_dishes = JSON.parse( Meal
            .select( 'meals.id as meal_id', 'dishes.id as dish_id' )
            .joins( 'LEFT JOIN dishes ON true' )
            .order( 'meals.priority', 'meals.name', 'dishes.priority', 'dishes.name' )
            .to_json, symbolize_names: true )

          empty_meal = Meal.find_by( code: '' )
          empty_dish = Dish.find_by( code: '' )

          mmd_sql_values = ''
          meals_dishes.each{ | md |
            mmd_sql_values += ",(#{ id },#{ md[ :meal_id ] },#{ md[ :dish_id ] }, " +
              "#{ md[ :meal_id ] == empty_meal.id && md[ :dish_id ] == empty_dish.id })" if
                 md[ :meal_id ] != empty_meal.id && md[ :dish_id ] != empty_dish.id ||
                 md[ :meal_id ] == empty_meal.id && md[ :dish_id ] == empty_dish.id
          }

          mmd_fieds = %w( menu_requirement_id meal_id dish_id is_enabled ).join( ',' )
          mmd_sql = "INSERT INTO menu_meals_dishes ( #{ mmd_fieds } ) VALUES #{ mmd_sql_values[1..-1] }"
          ActiveRecord::Base.connection.execute( "#{ sql_delete };#{ mmd_sql }" )

          menu_meals_dish = menu_requirement.menu_meals_dishes.find_by( meal: empty_meal, dish: empty_dish )
          ####

          error_children_categories = []
          params[ :children_categories ].each_with_index do | children_category_par, index |
            error = { children_category_code: 'Не знайдений параметр [children_category_code]',
                      count_all_plan: 'Не знайдений параметр [count_all_plan]',
                      count_exemption_plan: 'Не знайдений параметр [count_exemption_plan]' }
                      .stringify_keys!.except( *children_category_par.keys )

            if error.empty?
              children_category = children_category_code( children_category_par[ :children_category_code ].strip )

              unless error = children_category[ :error ]
                update_fields = { count_all_plan: children_category_par[ :count_all_plan ],
                                  count_exemption_plan: children_category_par[ :count_exemption_plan ],
                                  count_all_fact: children_category_par[ :count_all_plan ],
                                  count_exemption_fact: children_category_par[ :count_exemption_plan ] }
                menu_children_categories.create_with( update_fields )
                  .find_or_create_by( children_category: children_category ).update( update_fields )
              end
            end

            ( error_children_categories << { index: "Рядок [#{ index + 1 }]" }.merge!( error ) ) if error && error.any?
          end

          ### menu_products
          menu_products = MenuProduct
            .joins( :menu_meals_dish )
            .where( menu_meals_dishes: { menu_requirement_id:  id } )

          # menu_products.update_all( count_plan: 0, count_fact: 0 )

          error_products = []
          params[:products].each_with_index do | product_par, index |
            error = { children_category_code: 'Не знайдений параметр [children_category_code]',
                      product_code: 'Не знайдений параметр [product_code]',
                      count_plan: 'Не знайдений параметр [count_plan]' }.stringify_keys!.except( *product_par.keys )

            if error.empty?
              children_category = children_category_code( product_par[ :children_category_code ].strip )
              error.merge!( children_category[ :error ] ) if children_category[ :error ]

              product = product_code( product_par[ :product_code ].strip )
              error.merge!( product[ :error ] ) if product[ :error ]

              if error.empty?
                MenuProduct.create( children_category: children_category,
                                    product: product,
                                    menu_meals_dish: menu_meals_dish,
                                    count_plan: product_par[ :count_plan ],
                                    count_fact: product_par[ :count_plan ] )
              end
            end

            ( error_products << { index: "Рядок [#{ index + 1 }]" }.merge!( error ) ) if error && error.any?
          end

          error = {}
          error.merge!( children_categories: error_children_categories ) if error_children_categories.any?
          error.merge!( error_products: error_products ) if error_products.any?

          if error.empty?
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
                      menu_meals_dishes.menu_requirement_id = #{ id }
                    GROUP BY 1, 2;
                  DELETE FROM menu_products_prices WHERE
                    product_id NOT IN (
                      SELECT DISTINCT product_id
                        FROM menu_products
                        LEFT JOIN menu_meals_dishes ON
                          menu_products.menu_meals_dish_id = menu_meals_dishes.id
                        WHERE menu_meals_dishes.menu_requirement_id = menu_products_prices.menu_requirement_id
                    ) AND
                    menu_requirement_id = #{ id }
                SQL

            ActiveRecord::Base.connection.execute( sql_menu_products_price )

            File.open( "./public/web_get/cu_menu_requirement_plan.txt", 'a' ) { | f |
              f.write( "\n *** #{ Time.now} ***#{ params.to_json }" )
            }
          else
            raise ActiveRecord::Rollback
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
      : { result: true, number: number, id: id }
  end

  ###############################################################################################
  # POST /api/cu_menu_requirement_fact
  #  { "branch_code": "0003", "institution_code": "14", "number": "000000000002", "date": "1485296673", "splendingdate": "1485296673", "date_saf": "1485296673", "number_saf": "000000000001",
  #    "children_categories": [{ "children_category_code": "000000001", "count_all_fact": 55, "count_exemption_fact": 19 },
  #                            { "children_category_code": "000000002", "count_all_fact": 3, "count_exemption_fact": 7 }],
  #    "products": [{"children_category_code": "000000001", "product_code": "000000079  ", "count_fact": 15 },
  #                 {"children_category_code": "000000002", "product_code": "000000079  ", "count_fact": 21 }]
  #  }
  def menu_requirement_fact_update
    error = { branch_code: 'Не знайдений параметр [branch_code]',
              institution_code: 'Не знайдений параметр [institution_code]',
              number: 'Не знайдений параметр [number]',
              date: 'Не знайдений параметр [date]',
              splendingdate: 'Не знайдений параметр [splendingdate]',
              date_saf: 'Не знайдений параметр [date_saf]',
              number_saf: 'Не знайдений параметр [number_saf]',
              children_categories: 'Не знайдений параметр [children_categories]',
              products: 'Не знайдений параметр [products]' }.stringify_keys!.except( *params.keys )
    number = params[ :number ].strip
    id = 0
    if error.empty?
      branch = branch_code( params[ :branch_code ].strip )
      error.merge!( branch[ :error ] ) if branch[ :error ]

      institution = institution_code( params[ :institution_code ] )
      error.merge!( institution[ :error ] ) if institution[ :error ]

      if error.empty?
        menu_requirement = menu_requirement_number( institution, number )

        unless error = menu_requirement[ :error ]
          ActiveRecord::Base.transaction do
            id = menu_requirement.id
            date = date_int_to_str( params[ :date ] )
            splendingdate = params[ :splendingdate ].empty? ? date : date_int_to_str( params[ :splendingdate ] )
            menu_requirement.update( date: date, branch: branch,
                                     is_del_fact_1c: false,
                                     splendingdate: splendingdate,
                                     date_saf: date_int_to_str( params[ :date_saf ] ),
                                     number_saf: params[ :number_saf ] )

            ### menu_children_categories
            menu_children_categories = menu_requirement.menu_children_categories
            menu_children_categories.update_all( count_all_fact: 0, count_exemption_fact: 0 )

            menu_meals_dish = menu_requirement.menu_meals_dishes
              .find_or_create_by( meal: Meal.find_by( code: '' ), dish: Dish.find_by( code: '' ) )

            error_children_categories = []
            params[ :children_categories ].each_with_index do | children_category_par, index |
              error = { children_category_code: 'Не знайдений параметр [children_category_code]',
                        count_all_fact: 'Не знайдений параметр [count_all_fact]',
                        count_exemption_fact: 'Не знайдений параметр [count_exemption_fact]' }
                        .stringify_keys!.except( *children_category_par.keys )

              if error.empty?
                children_category = children_category_code( children_category_par[ :children_category_code ].strip )

                unless error = children_category[ :error ]
                  update_fields = { count_all_fact: children_category_par[ :count_all_fact ],
                                    count_exemption_fact: children_category_par[ :count_exemption_fact ] }
                  menu_children_categories.create_with( update_fields )
                    .find_or_create_by( children_category: children_category ).update( update_fields )
                end
              end

              ( error_children_categories << { index: "Рядок [#{ index + 1 }]" }.merge!( error ) ) if error && error.any?
            end

            ### menu_products
            menu_products = MenuProduct
              .joins( :menu_meals_dish )
              .where( 'menu_meals_dishes.menu_requirement_id = ? ', id )

            menu_products.where.not( menu_meals_dish: menu_meals_dish ).delete_all

            error_products = []
            params[ :products ].each_with_index do | product_par, index |
              error = { children_category_code: 'Не знайдений параметр [children_category_code]',
                        product_code: 'Не знайдений параметр [product_code]',
                        count_fact: 'Не знайдений параметр [count_fact]' }.stringify_keys!.except( *product_par.keys )

              if error.empty?
                children_category = children_category_code( product_par[ :children_category_code ].strip )
                error.merge!( children_category[ :error ] ) if children_category[ :error ]

                product = product_code( product_par[ :product_code ].strip )
                error.merge!( product[ :error ] ) if product[ :error ]

                if error.empty?
                  update_fields = { count_fact: product_par[ :count_fact ] }
                  menu_products.create_with( update_fields )
                    .find_or_create_by( children_category: children_category,
                                        product: product,
                                        menu_meals_dish: menu_meals_dish )
                    .update( update_fields )
                end
              end

              ( error_products << { index: "Рядок [#{ index + 1 }]" }.merge!( error ) ) if error && error.any?
            end

            error = {}
            error.merge!( children_categories: error_children_categories ) if error_children_categories.any?
            error.merge!( error_products: error_products ) if error_products.any?

            if error.empty?
              menu_children_categories.where( count_all_plan: 0, count_exemption_plan: 0, count_all_fact: 0,
                                              count_exemption_fact: 0 ).delete_all

              menu_products.where( count_plan: 0, count_fact: 0 ).delete_all
              menu_meals_dish.update( is_enabled: true )
              menu_requirement.menu_meals_dishes.where( is_enabled: false ).delete_all

              File.open( "./public/web_get/cu_menu_requirement_fact.txt", 'a' ) { | f |
                f.write( "\n *** #{ Time.now} ***#{ params.to_json }" )
              }
            else
              raise ActiveRecord::Rollback
            end
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
      : { result: true, number: number, id: id }
  end

  # GET api/menu_requirement?institution_code=14&number=000000000028
  def menu_requirement_view
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              number: 'Не знайдений параметр [number]' }.stringify_keys!.except( *params.keys )

    if error.size == 2
      error = {}
      menu_requirement = MenuRequirement.last
    else
      if error.empty?
        institution = institution_code( params[ :institution_code ] )

        unless error = institution[ :error ]
          menu_requirement = menu_requirement_number( institution, params[ :number ].strip )
          error = menu_requirement[ :error ]
        end
      end
    end

    render json: error.present? ? { result: false, error: [ error ] } :
    menu_requirement.to_json(
      only: [ :number, :date, :splendingdate, :date_sap, :date_saf ],
      include: {
        branch: { only: [ :code, :name ] },
        institution: { only: [ :code, :name ] },
        menu_children_categories: {
          only: [ :count_exemption_plan, :count_all_plan, :count_exemption_fact, :count_all_fact ],
          include: {
            children_category: { only: [ :code, :name ] } }
        },
        menu_meals_dishes: {
          include: {
            meal: { only: [ :code, :name ] },
            dish: { only: [ :code, :name ] },
            menu_products: {
              only: [ :count_plan, :count_fact ],
              include: {
                menu_meals_dish: {
                  include: {
                    meal: { only: [ :code, :name ] },
                    dish: { only: [ :code, :name ] },
                  }
                },
                children_category: { only: [ :code, :name ] },
                product: { only: [ :code, :name ] } }
            }
          }
        }
      }
    )
  end

  # DELETE api/menu_requirement { "institution_code": "14", "number": "KL-000000024", "type": 1 }
  def menu_requirement_delete
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              type: 'Не знайдений параметр [type]',
              number: 'Не знайдений параметр [number]' }.stringify_keys!.except( *params.keys )

    if error.empty?
      institution = institution_code( params[ :institution_code ] )

      unless error = institution[ :error ]
        number = params[ :number ]
        menu_requirement = menu_requirement_number( institution, number )
        error = menu_requirement[ :error ]
        unless error = menu_requirement[ :error ]
          type = params[ :type ]
          case type
          when 0 then menu_requirement.destroy
          when 1 then menu_requirement.update( is_del_plan_1c: true )
          when 2 then menu_requirement.update( is_del_fact_1c: true )
          else
            error = { type: "Такого значення не існує [#{ type }]" }
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
                     : { result: true, number: number, id: menu_requirement.id }
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_timesheet
  #  { "branch_code": "0003", "institution_code": "14", "number": "000000000002", "date": "1487548800",
  #    "date_vb": "1485907200", "date_ve": "1488240000", "date_eb": "1485907200", "date_ee": "1486684800",
  #    "date_sa": "1506902400", "number_sa": "000000000001",
  #    "dates": [ { "child_code": "000000001", "children_group_code": "000000001", "reasons_absence_code": "000000001", "date": "1485907200" },
  #               { "child_code": "000000001", "children_group_code": "000000001", "reasons_absence_code": "000000001", "date": "1485993600" } ]
  #  }
  def timesheet_update
    error = { branch_code: 'Не знайдений параметр [branch_code]',
              institution_code: 'Не знайдений параметр [institution_code]',
              number: 'Не знайдений параметр [number]',
              date: 'Не знайдений параметр [date]',
              date_vb: 'Не знайдений параметр [date_vb]',
              date_ve: 'Не знайдений параметр [date_ve]',
              date_eb: 'Не знайдений параметр [date_eb]',
              date_ee: 'Не знайдений параметр [date_ee]',
              date_sa: 'Не знайдений параметр [date_sa]',
              number_sa: 'Не знайдений параметр [number_sa]',
              dates: 'Не знайдений параметр [dates]' }.stringify_keys!.except( *params.keys )
    number = params[ :number ].strip
    id = 0
    if error.empty?
      branch = branch_code( params[ :branch_code ].strip )
      error.merge!( branch[ :error ] ) if branch[ :error ]

      institution = institution_code( params[ :institution_code ] )
      error.merge!( institution[ :error ] ) if institution[ :error ]

      if error.empty?
        ActiveRecord::Base.transaction do
          update_fields = { branch: branch,
                            is_del_1c: false,
                            date: date_int_to_str( params[ :date ] ),
                            date_vb: date_int_to_str( params[ :date_vb ] ),
                            date_ve: date_int_to_str( params[ :date_ve ] ),
                            date_eb: date_int_to_str( params[ :date_eb ] ),
                            date_ee: date_int_to_str( params[ :date_ee ] ),
                            date_sa: date_int_to_str( params[ :date_sa ] ),
                            number_sa: params[ :number_sa ] }

          if timesheet = institution.timesheets.find_by( number: number )
            timesheet.update( update_fields )
          else
            timesheet = Timesheet.create_with( update_fields ).create( institution: institution )
            number = timesheet.number
          end

          id = timesheet.id

          timesheet_dates = timesheet.timesheet_dates
          timesheet_dates.all.delete_all

          error_dates = []
          params[ :dates ].each_with_index do | dates_par, index |
            error = { child_code: 'Не знайдений параметр [child_code]',
                      children_group_code: 'Не знайдений параметр [children_group_code]',
                      reasons_absence_code: 'Не знайдений параметр [reasons_absence_code]',
                      date: 'Не знайдений параметр [date]' }.stringify_keys!.except( *dates_par.keys )

            if error.empty?
              child = child_code( dates_par[ :child_code ].strip )
              error.merge!( child[ :error ] ) if child[ :error ]

              children_group = children_group_code( dates_par[ :children_group_code ].strip )
              error.merge!( children_group[ :error ] ) if children_group[ :error ]

              reasons_absence = reasons_absence_code( dates_par[ :reasons_absence_code ].strip )
              error.merge!( reasons_absence[ :error ] ) if reasons_absence[ :error ]

              timesheet_dates.create( child: child, children_group: children_group, reasons_absence: reasons_absence,
                                      date: date_int_to_str( dates_par[ :date ] ) ) if error.empty?
            end

            ( error_dates << { index: "Рядок [#{ index + 1 }]" }.merge!( error ) ) if error && error.any?
          end

          if error_dates.any?
            error =  { dates: error_dates }
            raise ActiveRecord::Rollback
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
      : { result: true, number: number, id: id }
  end

  # GET api/timesheet?institution_code=14&number=000000000001
  def timesheet_view
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              number: 'Не знайдений параметр [number]' }.stringify_keys!.except( *params.keys )

    if error.size == 2
      error = {}
      timesheet = Timesheet.last
    else
      if error.empty?
        institution = institution_code( params[ :institution_code ] )

        unless error = institution[ :error ]
          timesheet = timesheet_number( institution, params[ :number ].strip )
          error = timesheet[ :error ]
        end
      end
    end

    render json: timesheet ? timesheet.to_json( include: { branch: { only: [ :code, :name ] },
        institution: { only: [ :code, :name ] }, timesheet_dates: { include: { child: { only: [ :code, :name ] },
        children_group: { only: [ :code, :name ] }, reasons_absence: { only: [ :code, :mark, :name ] } } } } )
      : { result: false, error: [ error ] }
  end
  ###############################################################################################

  # DELETE api/timesheet { "institution_code": "14", "number": "KL-000000028", "type": 1 }
  def timesheet_delete
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              type: 'Не знайдений параметр [type]',
              number: 'Не знайдений параметр [number]' }.stringify_keys!.except( *params.keys )

    if error.empty?
      institution = institution_code( params[ :institution_code ] )

      unless error = institution[ :error ]
        number = params[ :number ]
        timesheet = timesheet_number( institution, number )
        unless error = timesheet[ :error ]
          type = params[ :type ]
          case type
          when 0 then timesheet.destroy
          when 1 then timesheet.update( is_del_1c: true )
          else
            error = { type: "Такого значення не існує [#{ type }]" }
          end

        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] }
                     : { result: true, number: number, id: timesheet.id }
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_dishes_categories { "dishes_categories": [ { "code": "000000001", "name": "Перша страва", "priority": 1 }, { "code": "000000002", "name": "Друга страва", "priority": 2 } ] }
  def dishes_categories_update
    errors = []
    ids = []
    ActiveRecord::Base.transaction do
      params[ :dishes_categories ].each_with_index do | obj, index |
        error = { code: 'Не знайдений параметр [code]',
                  name: 'Не знайдений параметр [name]',
                  priority: 'Не знайдений параметр [priority]' }
          .stringify_keys!.except( *obj.keys )

        if error.empty?
          code = obj[ :code ].strip
          update_fields = { name: obj[ :name ], priority: obj[ :priority ] }
          dishes_category = DishesCategory.create_with( update_fields ).find_or_create_by( code: code )
          dishes_category.update( update_fields )
          ids << { code: code, id: dishes_category.id }
        else
          errors << { index: "Рядок [#{ index + 1 }]" }.merge( error )
        end
      end

      raise ActiveRecord::Rollback if errors.any?
    end

    render json: errors.any? ? { result: false, error: errors }
        : { result: true, dishes_categories: ids  }
  end

  # GET /api/dishes_categories?code=000000002
  def dishes_category_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = { }
      dishes_category = DishesCategory.last
    else
      if error.empty?
        dishes_category = dishes_category_code( params[ :code ].strip )
        error = dishes_category[ :error ]
      end
    end

    render json: dishes_category ? dishes_category.to_json : { result: false, error: [ error ] }
  end

  # GET /api/dishes_categories
  def dishes_categories_view
    render json: DishesCategory.all.order( :code ).to_json
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_meals { "meals": [ { "code": "000000001", "name": "Сніданок", "priority": 1 }, { "code": "000000002", "name": "Обід", "priority": 2 } ] }
  def meals_update
    errors = []
    ids = []
    ActiveRecord::Base.transaction do
      params[ :meals ].each_with_index do | obj, index |
        error = { code: 'Не знайдений параметр [code]',
                  name: 'Не знайдений параметр [name]',
                  priority: 'Не знайдений параметр [priority]' }
          .stringify_keys!.except( *obj.keys )

        if error.empty?
          code = obj[ :code ].strip
          update_fields = { name: obj[ :name ], priority: obj[ :priority ] }
          meal = Meal.create_with( update_fields ).find_or_create_by( code: code )
          meal.update( update_fields )
          ids << { code: code, id: meal.id }
        else
          errors << { index: "Рядок [#{ index + 1 }]" }.merge( error )
        end
      end

      raise ActiveRecord::Rollback if errors.any?
    end

    render json: errors.any? ? { result: false, error: errors }
        : { result: true, meals: ids  }
  end

  # GET /api/meal?code=000000002
  def meal_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = { }
      meal = Meal.last
    else
      if error.empty?
        meal = meal_code( params[ :code ].strip )
        error = meal[ :error ]
      end
    end

    render json: meal ? meal.to_json : { result: false, error: [ error ] }
  end

  # GET /api/meals
  def meals_view
    render json: Meal.all.order( :code ).to_json
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_dishes { "dishes": [ { "code": "000000001", "name": "Каша", "dishes_category_code": "000000001", "priority": 1 }, { "code": "000000002", "name": "Борщ", "dishes_category_code": "000000002", "priority": 2 } ] }
  def dishes_update
    errors = []
    ids = []
    ActiveRecord::Base.transaction do
      params[ :dishes ].each_with_index do | obj, index |
        error = { code: 'Не знайдений параметр [code]',
                  name: 'Не знайдений параметр [name]',
                  dishes_category_code: 'Не знайдений параметр [dishes_category_code]',
                  priority: 'Не знайдений параметр [priority]' }
          .stringify_keys!.except( *obj.keys )

        if error.empty?
          dishes_category = dishes_category_code( obj[ :dishes_category_code ].strip )
          unless error = dishes_category[ :error ]
            code = obj[ :code ].strip
            update_fields = { name: obj[ :name ], priority: obj[ :priority ], dishes_category: dishes_category }
            dish = Dish.create_with( update_fields ).find_or_create_by( code: code )
            dish.update( update_fields )
            ids << { code: code, id: dish.id }
          end
        end

        ( errors << { index: "Рядок [#{ index + 1 }]" }.merge!( error ) ) if error && error.any?
      end

      raise ActiveRecord::Rollback if errors.any?
    end

    render json: errors.any? ? { result: false, error: errors }
        : { result: true, dishes: ids  }
  end

  # GET api/dish?code=000000001
  def dish_view
    error = { code: 'Не знайдений параметр [code]' }.stringify_keys!.except( *params.keys )

    if error.size == 1
      error = { }
      dish = Dish.last
    else
      if error.empty?
        dish = dish_code( params[ :code ].strip )
        error = dish[ :error ]
      end
    end

    render json: dish ? dish.to_json( include: { dishes_category: { only: [ :code, :name ] } } )
      : { result: false, error: [ error ] }
  end

  # GET /api/dishes
  def dishes_view
    render json: Dish.all.order( :code ).to_json( include: { dishes_category: { only: [ :code, :name ] } } )
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_dishes_products_norms
  # { "dishes_products_norms":
  #   [
  #     { "institution_code": 14, "dish_code": "000000002", "product_code": "000000054", "children_category_code": "000000001", "amount": 0.01 },
  #     { "institution_code": 14, "dish_code": "000000002", "product_code": "000000047", "children_category_code": "000000001", "amount": 0.05 }
  #   ]
  # }
  def dishes_products_norms_update
    children_categories = JSON.parse( ChildrenCategory
      .select( :id, :code )
      .to_json, symbolize_names: true )

    products = JSON.parse( Product
      .select( :id, :code )
      .to_json, symbolize_names: true )

    dishes = JSON.parse( Dish
      .select( :id, :code )
      .to_json, symbolize_names: true )

    institutions = JSON.parse( Institution
      .select( :id, :code )
      .to_json, symbolize_names: true )

    dishes_products_all= JSON.parse( DishesProduct
      .joins( :institution, :dish, :product )
      .select( :id, :institution_id, :dish_id, :product_id )
      .to_json, symbolize_names: true )

    errors = [ ]

    dishes_products_norms = params.permit(
      dishes_products_norms: [ :institution_code, :dish_code, :product_code, :children_category_code, :amount]
    )[ :dishes_products_norms ]

    institutions_codes = dishes_products_norms.group_by { | o | o[ :institution_code ].to_i || 0 }.keys
    institutions = exists_codes( :institutions, institutions_codes )
    errors << institutions[ :error ] unless institutions[ :status ]

    dishes_codes = dishes_products_norms.group_by { | o | o[ :dish_code ] }.keys
    dishes = exists_codes( :dishes, dishes_codes )
    errors << dishes[ :error ] unless dishes[ :status ]

    products_codes = dishes_products_norms.group_by { | o | o[ :product_code ] }.keys
    products = exists_codes( :products, products_codes )
    errors << products[ :error ] unless products[ :status ]

    children_categories_codes = dishes_products_norms.group_by { | o | o[ :children_category_code ] }.keys
    children_categories = exists_codes( :children_categories, children_categories_codes )
    errors << children_categories[ :error ] unless children_categories[ :status ]

    if errors.empty?
      dishes_products_norms_update = dishes_products_norms
        .map.with_index { | o, i | o.merge!( index: i + 1 ) } # нумеруем индексы что бы в случае несоотвествия структуры вывести номер строки
        .group_by { | o | dishes_products_all # группируем с одновременным добавлением :id по :code
          .select { | t |
            t[ :institution_id ] == institutions[ :obj ][ o[ :institution_code ].to_i ] &&
            t[ :dish_id ] == dishes[ :obj ][ o[ :dish_code ] ] &&
            t[ :product_id ] == products[ :obj ][ o[ :product_code ] ] }
          .fetch(0, { # Если не нашло ничего значит добавляем ID = 0, это те записи которые будут вставлени в таблицу <dishes_products>
            id: 0,
            institution_id: institutions[ :obj ][ o[ :institution_code ].to_i ],
            dish_id: dishes[ :obj ][ o[ :dish_code ] ],
            product_id: products[ :obj ][ o[ :product_code ] ] } )
          .merge!(
            institution_code: o[ :institution_code ],
            dish_code: o[ :dish_code ],
            product_code: o[ :product_code ]
          )
        }

      dishes_products_new = dishes_products_norms_update.select { | k, _ | k[ :id ].zero? }

      if dishes_products_new.present? # Вставка недостающих записей в <dishes_products>
        fields_dp = %w( institution_id dish_id product_id ).join( ',' )
        values_dp = dishes_products_new
          .map { | k, _ | "( #{ k
            .slice( :institution_id, :dish_id, :product_id )
            .values.join( ',' ) }
          )" }.join(',')

        sql_dp = <<-SQL.squish
            INSERT INTO dishes_products ( #{ fields_dp } )
              VALUES #{ values_dp }
              RETURNING id, institution_id, dish_id, product_id  ;
          SQL

        dishes_products_insert = JSON.parse( ActiveRecord::Base.connection.execute( sql_dp )
          .to_json, symbolize_names: true )

        # Заменяем значения ID на новые те что вставленные
        dishes_products_insert.each { | o |
          dishes_products_norms_update.select { | t |
            t[ :institution_id ] == o[ :institution_id ] &&
            t[ :dish_id ] == o[ :dish_id ] &&
            t[ :product_id ] == o[ :product_id ] }.keys[0][:id] = o[ :id ]
        }
      end

      arr_values_dpn = [ ]

      dishes_products_norms_update.each do | key_dpnu, value_dpnu |
        value_dpnu.each do | obj |
          error = { institution_code: 'Не знайдений параметр [institution_code]',
            dish_code: 'Не знайдений параметр [dish_code]',
            product_code: 'Не знайдений параметр [product_code]',
            children_category_code: 'Не знайдений параметр [children_category_code]',
            amount: 'Не знайдений параметр [amount]' }.stringify_keys!.except( *obj.keys )

          if error.empty?
            arr_values_dpn << [ ].tap { | value |
              value << key_dpnu[ :id ]
              value << children_categories[ :obj ][ ( obj[ :children_category_code] || '' ).strip ]
              value << obj[ :amount ] || 0
            }
          else
            errors << { index: "Рядок [#{ obj[ :index ] }]" }.merge!( error )
          end
        end
      end

      if errors.empty?
        values_dpn = arr_values_dpn.map { | o | "( #{ o.join( ',' ) } )" }.join( ',' )

        sql_dpn = <<-SQL.squish
            INSERT INTO dishes_products_norms ( dishes_product_id, children_category_id, amount )
              VALUES #{ values_dpn }
              ON CONFLICT ( dishes_product_id, children_category_id )
                DO UPDATE SET amount = EXCLUDED.amount
              RETURNING id ;
          SQL

        ids = JSON.parse( ActiveRecord::Base.connection.execute( sql_dpn )
          .to_json, symbolize_names: true )
          .map{ | o | o[ :id ] }

        result = { status: true, ids: ids }
      else
        result = { status: false, errors: errors }
      end
    else
      result = { status: false, errors: errors }
    end

    render json: result
  end
  ###############################################################################################

  ###############################################################################################
  # POST /api/date_blocks
  # { "date_blocks":
  #   [
  #     { "institution_code": 14, "date_start": 1509494400, "date_end": 1510576706 }
  #   ]
  # }
  def date_blocks_update
    errors = [ ]
    ids = [ ]

    date_blocks = params.permit(
      date_blocks: [ :institution_code, :date_start, :date_end ]
    )[ :date_blocks ]

    institutions_codes = date_blocks.group_by { | o | o[ :institution_code ].to_i || 0 }.keys
    institutions = exists_codes( :institutions, institutions_codes )
    errors << institutions[ :error ] unless institutions[ :status ]

    if errors.empty?

      values_insert = [ ]

      date_blocks.each_with_index do | obj, index |
        error = {
          institution_code: 'Не знайдений параметр [institution_code]',
          date_start: 'Не знайдений параметр [date_start]',
          date_end: 'Не знайдений параметр [date_end]'
        }.stringify_keys!.except( *obj.keys )

        if error.empty?
          date_start = Time.at( obj[ :date_start ].to_i ).to_date
          date_end = Time.at( obj[ :date_end ].to_i ).to_date
          ( date_start..date_end ).each { | date |
            values_insert << [ ].tap { | value |
              value << institutions[ :obj ][ obj[ :institution_code ].to_i ]
              value << "'#{ date }'"
            }
          }
        else
          errors << { index: "Рядок [#{ index }]" }.merge!( error )
        end
      end

      if errors.empty?
        values_sql_insert = values_insert.map { | o | "( #{ o.join( ',' ) } )" }.join( ',' )

        sql = <<-SQL.squish
            INSERT INTO date_blocks ( institution_id, date )
              VALUES #{ values_sql_insert }
              ON CONFLICT ( institution_id, date ) DO NOTHING
              RETURNING id ;
          SQL

        ids = JSON.parse( ActiveRecord::Base.connection.execute( sql )
          .to_json, symbolize_names: true )
          .map{ | o | o[ :id ] }

        result = { status: true, ids: ids }
      else
        result = { status: false, errors: errors }
      end
    else
      result = { status: false, errors: errors }
    end

    render json: result
  end

  def date_blocks_delete
    errors = []
    ids = []

    date_blocks = params.permit(
      date_blocks: [ :institution_code, :date_start, :date_end ]
    )[ :date_blocks ]

    institutions_codes = date_blocks.group_by { | o | o[ :institution_code ].to_i || 0 }.keys
    institutions = exists_codes( :institutions, institutions_codes )
    errors << institutions[ :error ] unless institutions[ :status ]

    if errors.empty?
      values_delete = [ ]

      date_blocks.each_with_index do | obj, index |
        error = {
          institution_code: 'Не знайдений параметр [institution_code]',
          date_start: 'Не знайдений параметр [date_start]',
          date_end: 'Не знайдений параметр [date_end]'
        }.stringify_keys!.except( *obj.keys )

        if error.empty?
          values_delete << <<-SQL.squish
              ( institution_id = #{ institutions[ :obj ][ obj[ :institution_code ].to_i ] }
                AND
                date BETWEEN
                  '#{ Time.at( obj[ :date_start ].to_i ).to_date }'
                  AND
                  '#{ Time.at( obj[ :date_end ].to_i ).to_date }'
              )
            SQL
        else
          errors << { index: "Рядок [#{ index }]" }.merge!( error )
        end
      end

      if errors.empty?
        values_sql_delete = values_delete.join( ' OR ' )

        sql = <<-SQL.squish
            DELETE FROM date_blocks
              WHERE #{ values_sql_delete }
              RETURNING id ;
          SQL

        ids = JSON.parse( ActiveRecord::Base.connection.execute( sql )
          .to_json, symbolize_names: true )
          .map{ | o | o[ :id ] }

        result = { status: true, ids: ids }
      else
        result = { status: false, errors: errors }
      end
    else
      result = { status: false, errors: errors }
    end

    render json: result
  end

  ###############################################################################################
  # GET /api/print_menu_requirement?institution_code=14&number=018В-0000121

  def menu_requirement_print
    error = {
      institution_code: 'Не знайдений параметр [institution_code]',
      number: 'Не знайдений параметр [number]'
    }.stringify_keys!.except( *params.keys )

    if error.empty?
      menu_requirement = MenuRequirement
        .joins( institution: :branch )
        .select( :id, :number, :date, :splendingdate, :date_sap, :date_saf,
                 'branches.name AS branch_name',
                 'institutions.name AS institution_name' )
        .find_by( institutions: { code: params[ :institution_code ] },
                  number: params[ :number ] )
        .as_json

      if menu_requirement
        menu_requirement_id = menu_requirement[ 'id' ]

        menu_requirement.merge!( children_categories: MenuChildrenCategory
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
          .where( menu_meals_dishes: { menu_requirement_id: menu_requirement_id } )
          .order( 'meals.priority', 'meals.name',
                  'dishes.priority', 'dishes.name',
                  'children_categories.priority', 'children_categories.name',
                  'products_types.priority', 'products_types.name', 'products.name' )
          .as_json( except: :id ) )
        .to_json
      else
        error = { error: { menu_requirement: "Не знайдена меню-вимога [#{ params[ :number ] }]" } }
      end
    end
      render json: error && error.any? ? { result: false, error: [ error ] }
      : { result: true, json: menu_requirement }
  end

end
