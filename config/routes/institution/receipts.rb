# Поступление
namespace :receipts do
  get :index, path: '' # Главная страничка
  post :create # создание поступления
  post :update # Обновление шапки поступления
  get :products # Отображение товаров поступления
  post :product_update # Обновление количества
  post :send_sa # Веб-сервис отправки поступления
  #post :ajax_suppliers_autocomplete_source # Источник для автозаполнение для фильтрации поставщиков
  post :ajax_filter_supplier_orders # Фильтрация таблицы заявок
  post :ajax_filter_contracts
  post :ajax_filter_receipts # Фильтрация таблицы
  post :print # Веб-сервис отправки
  delete :delete # Удаление поступления
end