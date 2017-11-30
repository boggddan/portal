# Табель
namespace :products_moves do
  get :index, path: '' # Главная страничка
  post :filter # Фильтрация документов
  delete :delete # Удаление документа
  post :create # Создание документа
  get :products # Отображение товаров

  post :product_update # Обновление количества по продуктам
  post :prices # Обновление количества по продуктам
  post :update # Обновление реквизитов документа
  post :send_sa # Веб-сервис отправки переміщення
  post :confirmed # Веб-сервис отправки переміщення
end
