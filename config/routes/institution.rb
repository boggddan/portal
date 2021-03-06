namespace :institution do
  get :index, path: '', controller: :base # Главная страничка

  draw :receipts, :institution # Поступление

  draw :institution_orders, :institution  # Заявки садика

  draw :menu_requirements, :institution # Меню-требования

  draw :timesheets, :institution # Табель

  draw :products_moves, :institution # Переміщення

  draw :reports, :institution # Отчеты

  draw :reference_books, :institution # Довідники
end
