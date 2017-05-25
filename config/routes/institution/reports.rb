# Отчеты
namespace :reports do
  get :index, path: '' # Главная страничка
  get :children_day_cost # Вартість дітодня за меню-вимогами
  post :ajax_children_day_cost
  get :balances_in_warehouses # Залишки продуктів харчування
  post :ajax_balances_in_warehouses
  get :attendance_of_children # Табель обліку відвідування дітей
  post :ajax_attendance_of_children
end
