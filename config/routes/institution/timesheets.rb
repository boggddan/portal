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
