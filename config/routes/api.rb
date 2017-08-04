# Веб-сервисы
scope :api, controller: :sync_catalogs do
  # Обновление справочников
  post :branch_update, path: :cu_branch
  get :branch_view, path: :branch
  get :branches_view, path: :branches

  post :institution_update, path: :cu_institution
  get :institution_view, path: :institution
  get :institutions_view, path: :institutions

  post :product_update, path: :cu_product
  get :product_view, path: :product
  get :products_view, path: :products

  post :products_type_update, path: :cu_products_type
  get :products_type_view, path: :products_type
  get :products_types_view, path: :products_types

  post :supplier_update, path: :cu_supplier
  get :supplier_view, path: :supplier
  get :suppliers_view, path: :suppliers

  post :children_categories_type_update, path: :cu_children_categories_type
  get :children_categories_type_view, path: :children_categories_type
  get :children_categories_types_view, path: :children_categories_types

  post :children_category_update, path: :cu_children_category
  get :children_category_view, path: :children_category
  get :children_categories_view, path: :children_categories

  post :package_update, path: :cu_package
  get :package_view, path: :package
  get :packages_view, path: :packages

  post :causes_deviation_update, path: :cu_causes_deviation
  get :causes_deviation_view, path: :causes_deviation
  get :causes_deviations_view, path: :causes_deviations

  post :price_product_update, path: :cu_price_product
  get :price_product_view, path: :price_product
  get :price_products_view, path: :price_products

  post :children_day_cost_update, path: :cu_children_day_cost
  get :children_day_cost_view, path: :children_day_cost
  get :children_day_costs_view, path: :children_day_costs

  post :suppliers_package_update, path: :cu_suppliers_package
  get :suppliers_package_view, path: :suppliers_package
  get :suppliers_packages_view, path: :suppliers_packages

  post :child_update, path: :cu_child
  get :child_view, path: :child
  get :children_view, path: :children

  post :reasons_absence_update, path: :cu_reasons_absence
  get :reasons_absence_view, path: :reasons_absence
  get :reasons_absences_view, path: :reasons_absences

  post :children_group_update, path: :cu_children_group
  get :children_group_view, path: :children_group
  get :children_groups_view, path: :children_groups

  post :dishes_categories_update, path: :cu_dishes_categories
  get :dishes_category_view, path: :dishes_category
  get :dishes_categories_view, path: :dishes_categories

  post :meals_update, path: :cu_meals
  get :meal_view, path: :meal
  get :meals_view, path: :meals

  post :dishes_update, path: :cu_dishes
  get :dish_view, path: :dish
  get :dishes_view, path: :dishes

  # Обновление документов
  post :supplier_order_update, path: :cu_supplier_order
  get :supplier_order_view, path: :supplier_order
  delete :supplier_order_delete, path: :supplier_order

  post :receipt_update, path: :cu_receipt
  get :receipt_view, path: :receipt
  delete :receipt_delete, path: :receipt

  post :institution_order_update, path: :cu_institution_order
  get :institution_order_view, path: :institution_order
  delete :institution_order_delete, path: :institution_order

  post :io_correction_update, path: :cu_institution_order_correction
  get :io_correction_view, path: :institution_order_correction
  delete :io_correction_delete, path: :institution_order_correction

  post :menu_requirement_plan_update, path: :cu_menu_requirement_plan
  post :menu_requirement_fact_update, path: :cu_menu_requirement_fact
  get :menu_requirement_view, path: :menu_requirement
  delete :menu_requirement_delete, path: :menu_requirement

  post :timesheet_update, path: :cu_timesheet
  get :timesheet_view, path: :timesheet
  delete :timesheet_delete, path: :timesheet
end
