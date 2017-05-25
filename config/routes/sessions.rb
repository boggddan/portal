# Сесия
namespace :sessions do
  post :create # Создание входа в портал
end

get :log_in, controller: :sessions  # Главная страничка
get :log_out, controller: :sessions  # Выход пользователя