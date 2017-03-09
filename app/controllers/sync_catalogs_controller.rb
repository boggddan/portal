class SyncCatalogsController < ApplicationController
  skip_before_action :verify_log_in # Отключение фильтра проверки пользователя

  def branch_code( code )
    code = code.strip
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
    code = code.strip
    if supplier = Supplier.find_by( code: code )
      supplier
    else
      { error: { supplier: "Не знайдений код постачальника [#{ code }]" } }
    end
  end

  def children_categories_type_code( code )
    code = code.strip
    if children_categories_type = ChildrenCategoriesType.find_by( code: code )
      children_categories_type
    else
      { error: { children_categories_type: "Не знайдений тип категорії дітей [#{ code }]" } }
    end
  end

  def children_category_code( code )
    code = code.strip
    if children_category = ChildrenCategory.find_by( code: code )
      children_category
    else
      { error: { children_category: "Не знайдений код категорії дитини [#{ code }]" } }
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

  def child_code( code )
    code = code.strip
    if child = Child.find_by( code: code )
      child
    else
      { error: { child: "Не знайдений код дитини [#{ code }]" } }
    end
  end

  def reasons_absence_code( code )
    code = code.strip
    if reasons_absence = ReasonsAbsence.find_by( code: code )
      reasons_absence
    else
      { error: { reasons_absence: "Не знайдений код причини відсутності [#{ code }]" } }
    end
  end

  def children_group_code( code )
    code = code.strip
    if children_group = ChildrenGroup.find_by( code: code )
      children_group
    else
      { error: { children_group:  "Не знайдений код дитячої группи [#{ code }]" } }
    end
  end

  def supplier_order_number( branch, number )
    number = number.strip
    if supplier_order = SupplierOrder.find_by( branch: branch, number: number )
      supplier_order
    else
      { error: { supplier_order: "Не знайдений номер заявки постачальникам [#{ number }]" } }
    end
  end

  def receipt_number( supplier_order, contract_number, number )
    contract_number = contract_number.strip
    number = number.strip
    if receipt = Receipt.find_by( supplier_order: supplier_order, contract_number: contract_number, number: number )
      receipt
    else
      { error: { receipt: "Не знайдений номер поставки [#{ number }]" } }
    end
  end

  def institution_order_number( institution, number )
    number = number.strip
    if institution_order = InstitutionOrder.find_by( institution: institution, number: number )
      institution_order
    else
      { error: { institution_order: "Не знайдена заявка [#{ number }]" } }
    end
  end

  def io_correction_number( institution_order, number )
    number = number.strip
    if io_correction = IoCorrection.find_by( institution_order: institution_order, number: number )
      io_correction
    else
      { error: { institution_order_correction: "Не знайдена коригувальна заявка [#{ number }]" } }
    end
  end

  def menu_requirement_number( institution, number )
    number = number.strip
    if menu_requirement = MenuRequirement.find_by( institution: institution, number: number )
      menu_requirement
    else
      { error: { menu_requirement: "Не знайдена меню-вимога [#{ number }]" } }
    end
  end

  def timesheet_number( institution, number )
    number = number.strip
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
      Branch.create_with( update_fields ).find_or_create_by( code: code ).update( update_fields )
    end
    render json: error.any? ? { result: false, error: [ error ] } : { result: true, code: code }
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
  # POST /api/cu_institution { "code": "14", "name": "18 (ДОУ)", "branch_code": "0003" }
  def institution_update
    error = { code: 'Не знайдений параметр [code]', name: 'Не знайдений параметр [name]',
              branch_code: 'Не знайдений параметр [branch_code]' }.stringify_keys!.except( *params.keys )
    if error.empty?
      branch = branch_code( params[ :branch_code ].strip )
      unless error = branch[ :error ]
        code = params[ :code ].strip
        update_fields = { name: params[ :name ], branch: branch }
        Institution.create_with( update_fields ).find_or_create_by( code: code ).update( update_fields )
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] } : { result: true, code: code }
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
  # POST /api/cu_product { "code": "000000079", "name": "Баклажани" }
  def product_update
    error = { code: 'Не знайдений параметр [code]', name: 'Не знайдений параметр [name]' }
              .stringify_keys!.except( *params.keys )
    if error.empty?
      code = params[ :code ].strip
      update_fields = { name: params[ :name ] }
      Product.create_with( update_fields ).find_or_create_by( code: code ).update( update_fields )
    end
    render json: error.any? ? { result: false, error: [ error ] } : { result: true, code: code }
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

    render json: product ? product.to_json : { result: false, error: [ error ] }
  end

  # GET /api/products
  def products_view
    render json: Product.all.order( :code ).to_json
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
  # POST /api/cu_children_category { "code": "00000001", "name": "Яслі", "children_categories_type_code": "00000001" }
  def children_category_update
    error = { code: 'Не знайдений параметр [code]', name: 'Не знайдений параметр [name]',
              children_categories_type_code: 'Не знайдений параметр [children_categories_type_code]' }
              .stringify_keys!.except( *params.keys )
    if error.empty?
      children_categories_type = children_categories_type_code( params[ :children_categories_type_code ].strip )
      unless error = children_categories_type[ :error ]
        code = params[ :code ].strip
        update_fields = { name: params[ :name ], children_categories_type: children_categories_type }
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
  # POST /api/cu_price_product { "branch_code": "0003", "institution_code": "14", "product_code": "000000079  ", "price_date": "1485296673", "price": 30.25  }
  def price_product_update
    error = { branch_code: 'Не знайдений параметр [branch_code]',
              institution_code: 'Не знайдений параметр [institution_code]',
              product_code: 'Не знайдений параметр [product_code]',
              price_date: 'Не знайдений параметр [price_date]',
              price: 'Не знайдений параметр [price]' }.stringify_keys!.except( *params.keys )
    if error.empty?
      branch = branch_code( params[ :branch_code ].strip )
      error.merge!( branch[ :error ] ) if branch[ :error ]

      institution = institution_code( params[ :institution_code ] )
      error.merge!( institution[ :error ] ) if institution[ :error ]

      product = product_code( params[ :product_code ].strip )
      error.merge!( product[ :error ] ) if product[ :error ]

      if error.empty?
        update_fields = {  price: params[:price] }
        PriceProduct.create_with( update_fields ).find_or_create_by( branch: branch,
          institution: institution, product: product, price_date: date_int_to_str( params[ :price_date ] ) )
          .update( update_fields )
      end
    end

    render json: error.any? ? { result: false, error: [ error ] } : { result: true }
  end

  # GET /api/price_product?branch_code=0003&institution_code=14&product_code=000000079&price_date=2017-01-25
  def price_product_view
    error = { branch_code: 'Не знайдений параметр [branch_code]',
              institution_code: 'Не знайдений параметр [institution_code]',
              product_code: 'Не знайдений параметр [product_code]',
              price_date: 'Не знайдений параметр [price_date]' }.stringify_keys!.except( *params.keys )

    if error.size == 4
      error = {}
      price_product = PriceProduct.last
    else
      if error.empty?
        branch = branch_code( params[ :branch_code ].strip )
        error.merge!( branch[ :error ] ) if branch[ :error ]

        institution = institution_code( params[ :institution_code ] )
        error.merge!( institution[ :error ] ) if institution[ :error ]

        product = product_code( params[ :product_code ].strip )
        error.merge!( product[ :error ] ) if product[ :error ]

        if error.empty?
          price_product = price_product_date( branch, institution, product, params[ :price_date ] )
          error = price_product[ :error ]
        end
      end
    end

    render json: price_product ? price_product.to_json( include: {
        branch: { only: [ :code, :name ] }, institution: { only: [ :code, :name ] }, product: { only: [ :code, :name ] } } )
      : { result: false, error: [error] }
  end

  # GET /api/price_products
  def price_products_view
    render json: PriceProduct.all.order( :price_date ).to_json(
      include: { branch: { only: [ :code, :name ] }, institution: { only: [ :code, :name ] },
                 product: { only: [ :code, :name ] } } )
  end
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

  # GET /api/branches
  def children_view
    render json: Child.all.order( :code ).to_json
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
  # POST /api/cu_children_group { "code": "000000001", "name": "42/1", "children_category_code": "000000001" }
  def children_group_update
    error = { code: 'Не знайдений параметр [code]', name: 'Не знайдений параметр [name]',
              children_category_code: 'Не знайдений параметр [children_category_code]'  }
              .stringify_keys!.except( *params.keys )
    if error.empty?
      children_category = children_category_code( params[ :children_category_code ].strip )
      unless error = children_category[ :error ]
        code = params[ :code ].strip
        update_fields = { code: params[ :code ], name: params[ :name ], children_category: children_category }
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

    render json: children_group ? children_group.to_json( include: { children_category: { only: [ :code, :name ] } } )
      : { result: false, error: [ error ] }
  end

  # GET /api/children_groups
  def children_groups_view
    render json: ChildrenGroup.all.order( :code ).to_json( include: { children_category: { only: [ :code, :name ] } } )
  end
  ###############################################################################################

  ###############################################################################################

  #
  #   Обновление документов
  #

  ###############################################################################################
  # POST /api/cu_supplier_order
  # { "branch_code": "0003", "supplier_code": "15", "number": "00000011", "date": 1504224000, "date_start": 1498867200, "date_end": 1519862400,
  #   "products": [{"institution_code": "14", "product_code": "000000079", "contract_number": "BX-0000001", "date": 1504224000, "count": 12},
  #                {"institution_code": "14", "product_code": "000000046  ", "contract_number": "BX-0000001", "date": 1504224000, "count": 15}]
  # }
  def supplier_order_update
    error = { branch_code: 'Не знайдений параметр [branch_code]',
              supplier_code: 'Не знайдений параметр [supplier_code]',
              number: 'Не знайдений параметр [number]',
              date: 'Не знайдений параметр [date]',
              date_start: 'Не знайдений параметр [date_start]',
              date_end: 'Не знайдений параметр [date_end]',
              products: 'Не знайдений параметр [products]' }.stringify_keys!.except( *params.keys )

    if error.empty?
      supplier = supplier_code( params[ :supplier_code ].strip )
      error.merge!( supplier[ :error ] ) if supplier[ :error ]

      branch = branch_code( params[ :branch_code ].strip )
      error.merge!( branch[ :error ] ) if branch[ :error ]

      if error.empty?
        SupplierOrder.transaction do
          update_fields = { supplier: supplier, date: date_int_to_str( params[ :date ] ),
                            date_start: date_int_to_str( params[ :date_start ] ),
                            date_end: date_int_to_str( params[ :date_end ] ) }
          number = params[ :number ].strip

          if supplier_order = branch.supplier_orders.find_by( number: number )
            supplier_order.update( update_fields )
          else
            supplier_order = SupplierOrder.create_with( update_fields )
              .create( branch: branch, supplier: supplier, number: number )
          end

          supplier_order_products = supplier_order.supplier_order_products
          supplier_order_products.update_all( count: 0 )

          error_products = []
          params[ :products ].each_with_index do | product_par, index |
            error = { institution_code: 'Не знайдений параметр [institution_code]',
                      product_code: 'Не знайдений параметр [product_code]',
                      contract_number: 'Не знайдений параметр [contract_number]',
                      date: 'Не знайдений параметр [date]',
                      count: 'Не знайдений параметр [count]' }.stringify_keys!.except( *product_par.keys )

            if error.empty?
              institution = institution_code( product_par[ :institution_code ] )
              error.merge!( institution[ :error ] ) if institution[ :error ]

              product = product_code( product_par[ :product_code ].strip )
              error.merge!( product[ :error ] ) if product[ :error ]

              if error.empty?
                supplier_order_products.create_with( count: product_par[ :count ] )
                  .find_or_create_by( institution: institution, product: product,
                    contract_number: product_par[ :contract_number ].strip, date: date_int_to_str( product_par[ :date ] ) )
                  .update( count: product_par[ :count ] )
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

    render json: error && error.any? ? { result: false, error: [ error ] } : { result: true, number: number }
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
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_receipt
  # { "institution_code': "14", "supplier_order_number": "000000000003", "contract_number": "BX-0000001", "number": "0000000000011", "invoice_number": "00000012", "date": "1485296673", "date_sa": "1485296673", "number_sa": "000000000001",
  #   "products": [{"product_code": "000000079", "date": "1504224000", "count": 25},
  #                {"product_code": "000000046  ", "date": "1504224000", "count": 19}]
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
    if error.empty?
      institution = institution_code( params[ :institution_code ] )

      unless error = institution[ :error ]
        supplier_order = supplier_order_number( institution.branch, params[ :supplier_order_number ].strip )

        unless error = supplier_order[ :error ]
          Receipt.transaction do
            contact_number = params[ :contract_number ].strip
            update_fields = { invoice_number: params[ :invoice_number ].strip, date: date_int_to_str( params[ :date ] ),
                              date_sa: date_int_to_str( params[ :date_sa ] ), number_sa: params[ :number_sa ] }
            if receipt = supplier_order.receipts.find_by( institution: institution,
                 contract_number: contract_number, number: number )
              receipt.update( update_fields )
            else
              receipt = Receipt.create_with( update_fields ).create( supplier_order: supplier_order,
                institution: institution, contract_number: contract_number )
              number = receipt.number
            end

            receipt_products = receipt.receipt_products
            receipt_products.update_all( count: 0 )

            error_products = []
            params[ :products ].each_with_index do | product_par, index |
              error = { product_code: 'Не знайдений параметр [product_code]',
                        date: 'Не знайдений параметр [date]',
                        count: 'Не знайдений параметр [count]' }.stringify_keys!.except( *product_par.keys )
              if error.empty?
                product = product_code( product_par[ :product_code ].strip )

                unless error = product[ :error ]
                  update_fields = { count: product_par[ :count ] }
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

    render json: error && error.any? ? { result: false, error: [ error ] } : { result: true, number: number }
  end

  # GET /api/receipt?institution_code=14&supplier_order_number=000000000003&contract_number=BX-0000001&number=000000000003
  def receipt_view
    error = { institution_code: 'Не знайдений параметр [institution_code]',
              supplier_order_number: 'Не знайдений параметр [supplier_order_number]',
              contract_number: 'Не знайдений параметр [contract_number]',
              number: 'Не знайдений параметр [invoice_number]', }.stringify_keys!.except( *params.keys )

    if error.size == 4
      error = {}
      receipt = Receipt.last
    else
      institution = institution_code( params[ :institution_code ] )

      unless error = institution[ :error ]
        supplier_order = supplier_order_number( institution.branch, params[ :supplier_order_number ].strip )

        unless error = supplier_order[ :error ]
          receipt = receipt_number( supplier_order, params[ :contract_number ].strip, params[ :number ].strip )
          error = receipt[ :error ]
        end
      end
    end

    render json: receipt ? receipt.to_json( include: { supplier_order: { only: [:number, :date], include: {
        branch: { only: [ :code, :name ] }, supplier: { only: [ :code, :name ] } } },
        institution: { only: [ :code, :name ] }, receipt_products: { include: { product: { only: [ :code, :name ] } } } } )
      : { result: false, error: [ error ] }
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
    if error.empty?
      institution = institution_code( params[ :institution_code ] )

      unless error = institution[ :error ]
        InstitutionOrder.transaction do
          update_fields = { date: date_int_to_str( params[ :date ] ), date_start: date_int_to_str( params[ :date_start ] ),
                            date_end: date_int_to_str( params[ :date_end ] ), date_sa: date_int_to_str( params[ :date_sa ] ),
                            number_sa: params[ :number_sa ] }

          if institution_order = institution.institution_orders.find_by( number: number )
            institution_order.update( update_fields )
          else
            institution_order = InstitutionOrder.create_with( update_fields ).create( institution: institution )
            number = institution_order.number
          end

          institution_order_products = institution_order.institution_order_products
          institution_order_products.update_all( count: 0 )

          error_products = []
          params[ :products ].each_with_index do | product_par, index |
            error = { date: 'Не знайдений параметр [date]',
                      product_code: 'Не знайдений параметр [product_code]',
                      count: 'Не знайдений параметр [count]',
                      description: 'Не знайдений параметр [description]'}.stringify_keys!.except( *product_par.keys )

            if error.empty?
              product = product_code( product_par[ :product_code ].strip )

              unless error = product[ :error ]
                update_fields = { count: product_par[ :count ], description: product_par[ :description ] }
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
            institution_order_products.where( count: 0 ).delete_all
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] } : { result: true, number: number }
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
  ###############################################################################################

  ###############################################################################################
  # POST /api/cu_institution_order_correction
  # { "institution_code": "14", "institution_order_number": "000000000002", "number": "000000000004", "date": "1485296673", "date_sa": "1485296673", "number_sa": "000000000001",
  #  "products": [{"date": "1485296673", "product_code": "000000079  ", "diff": 7, "description": "1 тиждень"},
  #               {"date": "1485296673", "product_code": "000000048  ", "diff": 5, "description": "1 тиждень,3 тиждень"}]
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
    if error.empty?
      institution = institution_code( params[ :institution_code ] )

      unless error = institution[ :error ]
        institution_order = institution_order_number( institution, params[ :institution_order_number ].strip )

        unless error = institution_order[ :error ]
          IoCorrection.transaction do
            update_fields = { date: date_int_to_str( params[ :date ] ),
                              date_sa: date_int_to_str(params[ :date_sa ] ), number_sa: params[ :number_sa ] }

            if io_correction = institution_order.io_corrections.find_by( number: number )
              io_correction.update( update_fields )
            else
              io_correction = IoCorrection.create_with( update_fields ).create( institution_order: institution_order )
              number = io_correction.number
            end

            io_correction_products = io_correction.io_correction_products
            io_correction_products.update_all( diff: 0 )

            error_products = []
            params[ :products ].each_with_index do | product_par, index |
              error = { date: 'Не знайдений параметр [date]',
                        product_code: 'Не знайдений параметр [product_code]',
                        diff: 'Не знайдений параметр [diff]',
                        description: 'Не знайдений параметр [description]' }.stringify_keys!.except( *product_par.keys )

              if error.empty?
                product = product_code( product_par[ :product_code ].strip )

                unless error = product[ :error ]
                  update_fields = { diff: product_par[ :diff ], description: product_par[ :description ] }
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
              io_correction_products.where( diff: 0 ).delete_all
            end
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] } : { result: true, number: number }
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
    if error.empty?
      branch = branch_code( params[ :branch_code ].strip )
      error.merge!( branch[ :error ] ) if branch[ :error ]

      institution = institution_code( params[ :institution_code ] )
      error.merge!( institution[ :error ] ) if institution[ :error ]

      if error.empty?
        MenuRequirement.transaction do
          date = date_int_to_str( params[ :date ] )
          splendingdate = params[ :splendingdate ].empty? ? date : date_int_to_str( params[ :splendingdate ] )
          update_fields = { date: date, branch: branch, splendingdate: splendingdate,
                            date_sap: date_int_to_str( params[ :date_sap ] ), number_sap: params[ :number_sap ] }

          if menu_requirement = institution.menu_requirements.find_by( number: number )
            menu_requirement.update( update_fields )
          else
            menu_requirement = MenuRequirement.create_with( update_fields ).create( institution: institution )
            number = menu_requirement.number
          end

          ### menu_children_categories
          menu_children_categories = menu_requirement.menu_children_categories
          menu_children_categories.update_all( count_all_plan: 0, count_exemption_plan: 0, count_all_fact: 0,
                                               count_exemption_fact: 0 )

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
          menu_products = menu_requirement.menu_products
          menu_products.update_all( count_plan: 0, count_fact: 0 )

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
                update_fields = { count_plan: product_par[ :count_plan ], count_fact: product_par[ :count_plan ] }
                menu_products.create_with( update_fields )
                  .find_or_create_by( children_category: children_category, product: product ).update( update_fields )
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
          else
            raise ActiveRecord::Rollback
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] } : { result: true, number: number }
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
    if error.empty?
      branch = branch_code( params[ :branch_code ].strip )
      error.merge!( branch[ :error ] ) if branch[ :error ]

      institution = institution_code( params[ :institution_code ] )
      error.merge!( institution[ :error ] ) if institution[ :error ]

      if error.empty?
        menu_requirement = menu_requirement_number( institution, number )

        unless error = menu_requirement[ :error ]
          MenuRequirement.transaction do
            date = date_int_to_str( params[ :date ] )
            splendingdate = params[ :splendingdate ].empty? ? date : date_int_to_str( params[ :splendingdate ] )
            menu_requirement.update( date: date, branch: branch, splendingdate: splendingdate,
                                     date_saf: date_int_to_str( params[ :date_saf ] ), number_saf: params[ :number_saf ] )

            ### menu_children_categories
            menu_children_categories = menu_requirement.menu_children_categories
            menu_children_categories.update_all( count_all_fact: 0, count_exemption_fact: 0 )

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
            menu_products = menu_requirement.menu_products
            menu_products.update_all( count_fact: 0 )

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
                    .find_or_create_by( children_category: children_category, product: product ).update( update_fields )
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
            else
              raise ActiveRecord::Rollback
            end
          end
        end
      end
    end

    render json: error && error.any? ? { result: false, error: [ error ] } : { result: true, number: number }
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

    render json: menu_requirement ? menu_requirement.to_json( include: { branch: { only: [ :code, :name ] },
        institution: { only: [ :code, :name ] },
        menu_children_categories: { include: { children_category: { only: [ :code, :name ] } } },
        menu_products: { include: { children_category: { only: [ :code, :name ] },  product: { only: [ :code, :name ] } } } } )
      : { result: false, error: [ error ] }
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

    if error.empty?
      branch = branch_code( params[ :branch_code ].strip )
      error.merge!( branch[ :error ] ) if branch[ :error ]

      institution = institution_code( params[ :institution_code ] )
      error.merge!( institution[ :error ] ) if institution[ :error ]

      if error.empty?
        Timesheet.transaction do
          update_fields = { branch: branch, date: date_int_to_str( params[ :date ] ),
                            date_vb: date_int_to_str( params[ :date_vb ] ), date_ve: date_int_to_str( params[ :date_ve ] ),
                            date_eb: date_int_to_str( params[ :date_eb ] ), date_ee: date_int_to_str( params[ :date_ee ] ),
                            date_sa: date_int_to_str( params[ :date_sa ] ), number_sa: params[ :number_sa ] }

          if timesheet = institution.timesheets.find_by( number: number )
            timesheet.update( update_fields )
          else
            timesheet = Timesheet.create_with( update_fields ).create( institution: institution )
            number = timesheet.number
          end

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

    render json: error && error.any? ? { result: false, error: [ error ] } : { result: true, number: number }
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

end