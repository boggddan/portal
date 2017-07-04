# Меню-требования
namespace :menu_requirements do
  get :index, path: '' # Главная страничка
  post :ajax_filter_menu_requirements # Фильтрация документов
  delete :delete # Удаление документа
  get :products # Отображение товаров
  post :create # Создание документа
  post :children_category_update # Обновление количества по категориям
  post :product_update # Обновление количества по продуктам
  post :meals_dish_update #
  post :create_products

  post :update # Обновление реквизитов документа
  post :send_sap # Веб-сервис отправки плана меню-требования
  post :send_saf # Веб-сервис отправки факта меню-требования
end
