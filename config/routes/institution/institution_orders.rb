# Заявки садика
namespace :institution_orders do
  post :ajax_filter_institution_orders # Фильтрация таблицы заявок
  post :ajax_filter_corrections # Фильтрация корректировок заявки

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