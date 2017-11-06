# Отчеты
namespace :reports do
  post :ajax_report_base
  get :children_day_cost # Вартість дітодня за меню-вимогами
  get :balances_in_warehouses # Залишки продуктів харчування
  post :ajax_balances_in_warehouses
  get :attendance_of_children # Табель обліку відвідування дітей
  post :ajax_attendance_of_children
end
