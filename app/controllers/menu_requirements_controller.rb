class MenuRequirementsController < ApplicationController

  def ajax_filter_menu_requirements # Фильтрация документов
    if params[:date_start] && params[:date_start]
      date_start = params[:date_start] ? params[:date_start] : params[:date_end]
      date_end = params[:date_end] ? params[:date_end] : params[:date_start]
      @menu_requirements = MenuRequirement.where( institution: current_institution, date: date_start..date_end ).order( :date )
    end
  end

  def ajax_delete_menu_requirement # Удаление документа
    MenuRequirement.where(id: params[:id]).delete_all if params[:id].present?
  end

  def products # Отображение товаров
    @menu_requirement = MenuRequirement.find_by(id: params[:id])

    date = @menu_requirement.date
    institution_id = @menu_requirement.institution_id
    menu_requirement_id = @menu_requirement.id

    ####
    select_column = [:id, :children_category_id, :count_all_plan, :count_exemption_plan, :count_all_fact, :count_exemption_fact,
                     'children_categories.code', 'children_categories.name', 'aa.cost']

    joins_table = "INNER JOIN children_categories ON children_categories.id = menu_children_categories.children_category_id
                    LEFT OUTER JOIN
                      (SELECT children_category_id, cost
                        FROM children_day_costs
                        WHERE cost_date <= '#{date}'
                        GROUP BY children_category_id HAVING MAX(cost_date)) aa
                    ON aa.children_category_id = children_categories.id "

    @menu_children_categories = @menu_requirement.menu_children_categories.select(select_column).joins(joins_table).order('children_categories.name')
    ####

    ####
    select_column = [:product_id, 'products.code', 'products.name', 'aa.price']
    joins_table = "INNER JOIN products ON products.id = menu_products.product_id
                    LEFT OUTER JOIN
                      (SELECT product_id, price FROM price_products
                        WHERE price_date <= '#{date}' AND institution_id = #{institution_id}
                        GROUP BY product_id HAVING MAX(price_date)) aa
                    ON aa.product_id = menu_products.product_id "
    column_fact_all = ''
    column_plan_all = ''
    @menu_children_categories.each_with_index do |menu_children_category, index|
      select_column << [ "b#{index}.id AS id_#{index}",
                        "b#{index}.count_fact AS count_fact_#{index}",
                        "b#{index}.count_plan AS count_plan_#{index}",
                        "ifnull(b#{index}.count_fact, 0) - ifnull(b#{index}.count_plan, 0) AS count_diff_#{index}",
                        "round(ifnull(b#{index}.count_fact, 0) * aa.price, 2) as sum_fact_#{index}",
                        "round(ifnull(b#{index}.count_plan, 0) * aa.price, 2) as sum_plan_#{index}" ]

      joins_table = joins_table +
        "LEFT OUTER JOIN
          (SELECT id, product_id, count_fact, count_plan
            FROM menu_products
            WHERE menu_requirement_id = #{menu_requirement_id} AND children_category_id = #{menu_children_category.children_category_id}) b#{index}
        ON b#{index}.product_id = menu_products.product_id "

      if index == @menu_children_categories.size-1
         select_column << ["round(#{column_fact_all} + ifnull(b#{index}.count_fact, 0), 3)  AS count_fact_all",
                           "round(#{column_plan_all} + ifnull(b#{index}.count_plan, 0), 3)  AS count_plan_all" ]
      else
        column_fact_all = column_fact_all + "ifnull(b#{index}.count_fact, 0) + "
        column_plan_all = column_plan_all + "ifnull(b#{index}.count_plan, 0) + "
      end
    end

    @menu_products = @menu_requirement.menu_products.select(select_column).joins(joins_table).group(:product_id).order('products.name')
    ####

  end

  def create # Создание документа
    MenuRequirement.transaction do
      menu_requirement = MenuRequirement.create!(institution: current_institution, branch: current_branch)

      ChildrenCategory.all.each do |children_category|
        MenuChildrenCategory.create!(menu_requirement: menu_requirement, children_category: children_category)

        Product.all.order(:name).each do |product|
          MenuProduct.create!(menu_requirement: menu_requirement, children_category: children_category, product: product)
        end
      end

      redirect_to menu_requirements_products_path(id: menu_requirement.id)
    end

  end

  def children_category_update # Обновление количества по категориям
    update = params.permit(:count_all_plan, :count_exemption_plan, :count_all_fact, :count_exemption_fact).to_h
    MenuChildrenCategory.where(id: params[:id]).update_all(update) if params[:id] && update.present?
  end

  def product_update # Обновление количества по продуктам
    update = params.permit(:count_plan, :count_fact).to_h
    MenuProduct.where(id: params[:id]).update_all(update) if params[:id] && update.present?
  end

  def update # Обновление реквизитов документа
    update = params.permit( :date, :splendingdate ).to_h
    MenuRequirement.where(id: params[:id]).update_all(update) if params[:id] && update.any?
  end

  def send_sap # Веб-сервис отправки плана меню-требования
    menu_requirement = MenuRequirement.find_by( id: params[:id] )
    menu_children_categories = menu_requirement.menu_children_categories.where.not( count_all_plan: 0 ).or( menu_requirement.menu_children_categories.where.not( count_exemption_plan: 0 ) )
    menu_requirement_products = menu_requirement.menu_products.where.not( count_plan: 0 )

    if menu_requirement_products.present? && menu_requirement_products.present?
      message = { 'CreateRequest' => { 'ins0:Branch_id' => menu_requirement.institution.branch.code,
                                       'ins0:Institutions_id' =>  menu_requirement.institution.code,
                                       'ins0:SplendingDate' =>menu_requirement.splendingdate,
                                       'ins0:Date' => menu_requirement.date,
                                       'ins0:Goods' => menu_requirement_products.map{ |o| {
                                         'ins0:CodeOfCategory' => o.children_category.code,
                                         'ins0:CodeOfGoods' => o.product.code,
                                         'ins0:Quantity' => o.count_plan.to_s } },
                                       'ins0:Categories' => menu_children_categories.map{ |o| {
                                         'ins0:CodeOfCategory' => o.children_category.code,
                                         'ins0:QuantityAll' => o.count_all_plan,
                                         'ins0:QuantityExemption' => o.count_exemption_plan } },
                                       'ins0:NumberFromWebPortal' => menu_requirement.number
      } }

      response = Savon.client( wsdl: $ghSavon[:wsdl], namespaces:  $ghSavon[:namespaces] ).call( :create_menu_requirement_plan, message: message )
      return_value = response.body[:create_menu_requirement_plan_response][:return]

      if return_value[:interface_state] && return_value[:interface_state] == 'OK'
        menu_requirement.update!( date_sap: Date.today, number_sap: return_value[:respond] )
        menu_children_categories.update_all( 'count_all_fact = count_all_plan, count_exemption_fact = count_exemption_plan' )
        menu_requirement_products.update_all( 'count_fact = count_plan' );
      end
    end

    redirect_to menu_requirements_products_path( id: params[:id] )
  end

  def send_saf # Веб-сервис отправки факта меню-требования
    menu_requirement = MenuRequirement.find_by( id: params[:id] )
    menu_children_categories = menu_requirement.menu_children_categories.where.not( count_all_fact: 0 ).or( menu_requirement.menu_children_categories.where.not( count_exemption_fact: 0 ) )
    menu_requirement_products = menu_requirement.menu_products.where.not( count_fact: 0 )

    if menu_children_categories && menu_requirement_products
      message = { 'CreateRequest' => { 'ins0:Branch_id' => menu_requirement.institution.branch.code,
                                       'ins0:Institutions_id' =>  menu_requirement.institution.code,
                                       'ins0:SplendingDate' =>menu_requirement.splendingdate,
                                       'ins0:Date' => menu_requirement.date,
                                       'ins0:Goods' => menu_requirement_products.map{|o| {
                                         'ins0:CodeOfCategory' => o.children_category.code,
                                         'ins0:CodeOfGoods' => o.product.code,
                                         'ins0:Quantity' => o.count_fact.to_s }},
                                       'ins0:Categories' => menu_children_categories.map{|o| {
                                         'ins0:CodeOfCategory' => o.children_category.code,
                                         'ins0:QuantityAll' => o.count_all_fact,
                                         'ins0:QuantityExemption' => o.count_exemption_fact }},
                                       'ins0:NumberFromWebPortal' => menu_requirement.number
      }}
      response = Savon.client( wsdl: $ghSavon[:wsdl], namespaces:  $ghSavon[:namespaces] ).call( :create_menu_requirement_fact, message: message )
      return_value = response.body[:create_menu_requirement_fact_response][:return]

      if return_value[:interface_state] && return_value[:interface_state] == 'OK' then
        menu_requirement.update!( date_saf: Date.today, number_saf: ( return_value[:respond] if return_value[:respond] ) )

        menu_requirement.menu_children_categories.where( count_all_plan: 0, count_exemption_plan: 0, count_all_fact: 0, count_exemption_fact: 0 ).delete_all
        menu_requirement.menu_products.where( count_plan: 0, count_fact: 0 ).delete_all
      end
    end

    redirect_to menu_requirements_products_path( id: params[:id] )
  end

end
