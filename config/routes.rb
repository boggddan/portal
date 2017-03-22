Rails.application.routes.draw do

  root 'application#index'

  #root 'institution/institution_orders#index'

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

    post :supplier_update, path: :cu_supplier
    get :supplier_view, path: :supplier
    get :suppliers_view, path: :suppliers

    post :children_categories_type_update, path: :cu_children_categories_type
    get :children_categories_type_view, path: :children_categories_type
    get :children_categories_types_view, path: :children_categories_types

    post :children_category_update, path: :cu_children_category
    get :children_category_view, path: :children_category
    get :children_categories_view, path: :children_categories

    post :causes_deviation_update, path: :cu_causes_deviation
    get :causes_deviation_view, path: :causes_deviation
    get :causes_deviations_view, path: :causes_deviations

    post :price_product_update, path: :cu_price_product
    get :price_product_view, path: :price_product
    get :price_products_view, path: :price_products

    post :children_day_cost_update, path: :cu_children_day_cost
    get :children_day_cost_view, path: :children_day_cost
    get :children_day_costs_view, path: :children_day_costs

    post :child_update, path: :cu_child
    get :child_view, path: :child
    get :children_view, path: :children

    post :reasons_absence_update, path: :cu_reasons_absence
    get :reasons_absence_view, path: :reasons_absence
    get :reasons_absences_view, path: :reasons_absences

    post :children_group_update, path: :cu_children_group
    get :children_group_view, path: :children_group
    get :children_groups_view, path: :children_groups

    #   Обновление документов
    post :supplier_order_update, path: :cu_supplier_order
    get :supplier_order_view, path: :supplier_order

    post :receipt_update, path: :cu_receipt
    get :receipt_view, path: :receipt

    post :institution_order_update, path: :cu_institution_order
    get :institution_order_view, path: :institution_order

    post :io_correction_update, path: :cu_institution_order_correction
    get :io_correction_view, path: :institution_order_correction

    post :menu_requirement_plan_update, path: :cu_menu_requirement_plan
    post :menu_requirement_fact_update, path: :cu_menu_requirement_fact
    get :menu_requirement_view, path: :menu_requirement

    post :timesheet_update, path: :cu_timesheet
    get :timesheet_view, path: :timesheet
  end

  namespace :institution do
    # Поступление
    namespace :receipts do
      get :index, path: '' # Главная страничка
      post :create # создание поступления
      post :update # Обновление шапки поступления
      get :products # Отображение товаров поступления
      post :product_update # Обновление количества
      post :send_sa # Веб-сервис отправки поступления
      get :ajax_suppliers_autocomplete_source # Источник для автозаполнение для фильтрации поставщиков
      get :ajax_filter_supplier_orders # Фильтрация таблицы заявок
      get :ajax_filter_contract_numbers
      get :ajax_filter_receipts # Фильтрация таблицы поступлений
      delete :delete # Удаление поступления
    end

    # Заявки садика
    namespace :institution_orders do
      get :ajax_filter_institution_orders # Фильтрация таблицы заявок
      get :ajax_filter_io_corrections # Фильтрация корректировок заявки

      get :index, path: '' # Главная страничка
      post :create # создание заявки
      get :products # Отображение товаров заявки
      post :product_update # Обновление количества
      post :update # Обновление реквизитов документа заявки
      post :send_sa # Веб-сервис отправки
      delete :delete # Удаление

      post :correction_create # Создания корректировки заявки
      delete :correction_delete # Удаление корректировки заявки
      get :correction_products # Отображение товаров корректировки заявки
      post :correction_update # Обновление реквизитов документа корректировки заявки
      post :correction_product_update # Обновление количества корректировки заявки
      post :correction_send_sa # Веб-сервис отправки корректировки
    end

    # Меню-требования
    namespace :menu_requirements do
      get :index, path: '' # Главная страничка
      get :ajax_filter_menu_requirements # Фильтрация документов
      delete :delete # Удаление документа
      get :products # Отображение товаров
      post :create # Создание документа
      post :children_category_update # Обновление количества по категориям
      post :product_update # Обновление количества по продуктам
      post :update # Обновление реквизитов документа
      post :send_sap # Веб-сервис отправки плана меню-требования
      post :send_saf # Веб-сервис отправки факта меню-требования
    end

    # Табель
    namespace :timesheets do
      get :index, path: '' # Главная страничка
      get :ajax_filter_timesheets # Фильтрация документов
      delete :delete # Удаление документа
      get :dates # Отображение дней табеля
      get :ajax_filter_timesheet_dates # Фильтрация таблицы
      get :new #
      post :create # Создание документа
      post :update # Обновление реквизитов документа
      post :dates_update # Обновление маркера
      post :send_sa # Веб-сервис отправки табеля
    end


    # Отчеты
    namespace :reports do
      get :index, path: '' # Главная страничка
      get :children_day_cost # Вартість дітодня за меню-вимогами
      post :ajax_children_day_cost_create # Создание
    end

  end


  # Пользователи
  namespace :admin do
    namespace :users do
      get :index, path: '' # Главная страничка
      get :new
      post :create # создание поступления
      delete :delete # Удаление
    end
  end

  # Сесия
  namespace :sessions do
    post :create # Создание входа в портал
  end

  get :log_in, controller: :sessions  # Главная страничка
  get :log_out, controller: :sessions  # Выход пользователя

end
