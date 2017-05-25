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