# Пользователи
namespace :users do
  get :index, path: '' # Главная страничка
  get :new
  post :filter_users
  post :create # создание поступления
  delete :delete # Удаление
end
