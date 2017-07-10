# Пользователи
namespace :admin do
  get :index, path: '', controller: :base # Главная страничка

  draw :users, :admin # Пользователи
end
