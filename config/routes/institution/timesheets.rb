# Табель
namespace :timesheets do
  get :index, path: '' # Главная страничка
  post :ajax_filter_timesheets # Фильтрация документов
  delete :delete # Удаление документа
  get :new #
  post :create # Создание документа

  get :dates # Отображение дней табеля
  post :ajax_filter_timesheet_dates # Фильтрация таблицы
  post :update # Обновление реквизитов документа
  post :refresh # Обновление данных о детях
  post :dates_update # Обновление маркера
  post :dates_updates # Обновление группы маркеров
  post :send_sa # Веб-сервис отправки табеля
end
