# Отчеты
namespace :reports do
  post :ajax_report_base
  get :cost_baby_day #
  post :ajax_cost_baby_day
  get :balances_in_warehouses # Залишки продуктів харчування
  post :ajax_balances_in_warehouses
  get :attendance_of_children # Табель обліку відвідування дітей
  post :ajax_attendance_of_children

  get :payment_of_parents # Взаєморозрахунки з батьками
  post :ajax_payment_of_parents
end
