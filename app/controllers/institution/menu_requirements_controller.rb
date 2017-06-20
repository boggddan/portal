class Institution::MenuRequirementsController < Institution::BaseController

  def index
  end

  def ajax_filter_menu_requirements # Фильтрация документов
    @menu_requirements = MenuRequirement
      .where( institution: current_institution, date: params[ :date_start ]..params[ :date_end ] )
      .order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
  end

  def delete # Удаление документа
    id = params[ :id ]

    ActiveRecord::Base.transaction do
      MenuProduct.where( menu_requirement_id: id ).delete_all
      MenuChildrenCategory.where( menu_requirement_id: id ).delete_all
      MenuRequirement.where( id: id ).delete_all
    end

    render json: { status: true }
  end

  def products # Отображение товаров
    @menu_requirement = MenuRequirement.find( params[ :id ] )

    date = @menu_requirement.date
    institution_id = @menu_requirement.institution_id
    menu_requirement_id = @menu_requirement.id

    ####
    select_column = [ :id, :children_category_id, :count_all_plan, :count_exemption_plan, :count_all_fact,
                     :count_exemption_fact, 'children_categories.code', 'children_categories.name', 'aa.cost' ]

    joins_table = "INNER JOIN children_categories
                    ON children_categories.id = menu_children_categories.children_category_id
                    LEFT OUTER JOIN
                      (SELECT DISTINCT ON(children_category_id) children_category_id, cost
                        FROM children_day_costs
                        WHERE cost_date <= '#{ date }'
                        ORDER BY children_category_id, cost_date DESC ) aa
                    ON aa.children_category_id = children_categories.id "

    @menu_children_categories = @menu_requirement.menu_children_categories.select( select_column )
                                  .joins( joins_table ).order( 'children_categories.name' )
    ####

    ####
    select_column = [ :product_id, 'MAX(products.code) as code', 'MAX(products.name) as name', 'MAX(COALESCE(aa.price, 0)) as price' ]
    joins_table = "INNER JOIN products ON products.id = menu_products.product_id
                    LEFT OUTER JOIN
                      (SELECT DISTINCT ON(product_id) product_id, price FROM price_products
                        WHERE price_date <= '#{ date }' AND institution_id = #{institution_id}
                        ORDER BY product_id, price_date DESC) aa
                    ON aa.product_id = menu_products.product_id "
    column_fact_all = ''
    column_plan_all = ''
    @menu_children_categories.each_with_index do | menu_children_category, index |
      select_column << [ "MAX(b#{ index }.id) AS id_#{index}",
                        "MAX(b#{ index }.count_fact) AS count_fact_#{ index }",
                        "MAX(b#{ index }.count_plan) AS count_plan_#{ index }",
                        "#{ @menu_requirement.number_sap ? "MAX(COALESCE(b#{ index }.count_fact, 0) - COALESCE(b#{ index }.count_plan, 0))" : "0" } AS count_diff_#{ index }",
                        "MAX(ROUND(COALESCE(b#{ index }.count_fact, 0) * COALESCE(aa.price, 0), 2)) AS sum_fact_#{ index }",
                        "MAX(ROUND(COALESCE(b#{ index }.count_plan, 0) * COALESCE(aa.price, 0), 2)) AS sum_plan_#{ index }" ]

      joins_table = joins_table +
        "LEFT OUTER JOIN
          (SELECT id, product_id, count_fact, count_plan
            FROM menu_products
            WHERE menu_requirement_id = #{ menu_requirement_id }
              AND children_category_id = #{ menu_children_category.children_category_id }) b#{ index }
        ON b#{ index }.product_id = menu_products.product_id "

      if index == @menu_children_categories.size - 1
         select_column << [ "MAX(ROUND(#{ column_fact_all } + COALESCE(b#{ index }.count_fact, 0), 3))  AS count_fact_all",
                           "MAX(ROUND(#{ column_plan_all } + COALESCE(b#{ index }.count_plan, 0), 3))  AS count_plan_all" ]
      else
        column_fact_all = column_fact_all + "COALESCE(b#{ index }.count_fact, 0) + "
        column_plan_all = column_plan_all + "COALESCE(b#{ index }.count_plan, 0) + "
      end
    end

    @menu_products = @menu_requirement.menu_products.select( select_column ).joins( joins_table )
                       .group(:product_id).order( 3 )
  end

  def create # Создание документа
    result = { }

    ActiveRecord::Base.transaction do
      menu_requirement = MenuRequirement.create!( institution: current_institution, branch: current_branch )

      current_institution.children_categories.each do | children_category |
        MenuChildrenCategory.create!( menu_requirement: menu_requirement, children_category: children_category )

        Product.all.order( :name ).each do | product |
          MenuProduct.create!( menu_requirement: menu_requirement, children_category: children_category, product: product )
        end
      end

      result = { status: true, urlParams: { id: menu_requirement.id } }
    end

    render json: result
  end

  def children_category_update # Обновление количества по категориям
    update = params.permit( :count_all_plan, :count_exemption_plan, :count_all_fact, :count_exemption_fact ).to_h
    MenuChildrenCategory.where(id: params[:id]).update_all(update) if params[:id] && update.present?
  end

  def product_update # Обновление количества по продуктам
    update = params.permit(:count_plan, :count_fact).to_h
    MenuProduct.where(id: params[:id]).update_all(update) if params[:id] && update.present?
  end

  def update # Обновление реквизитов документа
    update = params.permit( :splendingdate ).to_h
    MenuRequirement.where( id: params[:id]).update_all( update ) if params[:id] && update.any?
  end

  def send_sap # Веб-сервис отправки плана меню-требования
    menu_requirement = MenuRequirement.find_by( id: params[:id] )
    menu_children_categories = menu_requirement.menu_children_categories.where.not( count_all_plan: 0 ).or( menu_requirement.menu_children_categories.where.not( count_exemption_plan: 0 ) )
    menu_requirement_products = menu_requirement.menu_products.where.not( count_plan: 0 )

    if menu_requirement_products.present? && menu_requirement_products.present?
      message = { 'CreateRequest' => { 'Branch_id' => menu_requirement.institution.branch.code,
                                       'Institutions_id' =>  menu_requirement.institution.code,
                                       'SplendingDate' =>menu_requirement.splendingdate,
                                       'Date' => menu_requirement.date,
                                       'Goods' => menu_requirement_products.map{ |o| {
                                         'CodeOfCategory' => o.children_category.code,
                                         'CodeOfGoods' => o.product.code,
                                         'Quantity' => o.count_plan.to_s } },
                                       'Categories' => menu_children_categories.map{ |o| {
                                         'CodeOfCategory' => o.children_category.code,
                                         'QuantityAll' => o.count_all_plan,
                                         'QuantityExemption' => o.count_exemption_plan } },
                                       'NumberFromWebPortal' => menu_requirement.number,
                                       'User' => current_user.username } }

      response = Savon.client( SAVON )
                     .call( :create_menu_requirement_plan, message: message )
      return_value = response.body[ :create_menu_requirement_plan_response ][ :return ]

      if return_value[ :interface_state ] && return_value[ :interface_state ] == 'OK'
        menu_requirement.update!( date_sap: Date.today, number_sap: return_value[ :respond ] )
        menu_children_categories.update_all( 'count_all_fact = count_all_plan, count_exemption_fact = count_exemption_plan' )
        menu_requirement_products.update_all( 'count_fact = count_plan' );
      end
    end

    redirect_to institution_menu_requirements_products_path( id: params[:id] )
  end

  def send_saf # Веб-сервис отправки факта меню-требования
    menu_requirement = MenuRequirement.find_by( id: params[:id] )
    menu_children_categories = menu_requirement.menu_children_categories.where.not( count_all_fact: 0 ).or( menu_requirement.menu_children_categories.where.not( count_exemption_fact: 0 ) )
    menu_requirement_products = menu_requirement.menu_products.where.not( count_fact: 0 )

    if menu_children_categories && menu_requirement_products
      message = { 'CreateRequest' => { 'Branch_id' => menu_requirement.institution.branch.code,
                                       'Institutions_id' =>  menu_requirement.institution.code,
                                       'SplendingDate' =>menu_requirement.splendingdate,
                                       'Date' => menu_requirement.date,
                                       'Goods' => menu_requirement_products.map{|o| {
                                         'CodeOfCategory' => o.children_category.code,
                                         'CodeOfGoods' => o.product.code,
                                         'Quantity' => o.count_fact.to_s }},
                                       'Categories' => menu_children_categories.map{|o| {
                                         'CodeOfCategory' => o.children_category.code,
                                         'QuantityAll' => o.count_all_fact,
                                         'QuantityExemption' => o.count_exemption_fact }},
                                       'NumberFromWebPortal' => menu_requirement.number,
                                       'User' => current_user.username } }

      response = Savon.client( SAVON ).call( :create_menu_requirement_fact, message: message )
      return_value = response.body[:create_menu_requirement_fact_response][:return]

      if return_value[:interface_state] && return_value[:interface_state] == 'OK' then
        menu_requirement.update!( date_saf: Date.today, number_saf: ( return_value[:respond] if return_value[:respond] ) )

        menu_requirement.menu_children_categories.where( count_all_plan: 0, count_exemption_plan: 0, count_all_fact: 0, count_exemption_fact: 0 ).delete_all
        menu_requirement.menu_products.where( count_plan: 0, count_fact: 0 ).delete_all
      end
    end

    redirect_to institution_menu_requirements_products_path( id: params[ :id ] )
  end

end
