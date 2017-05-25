Rails.application.routes.draw do
  root 'application#index'

  draw :api

  draw :institution

  draw :admin # Пользователи

  draw :sessions # Сесия
end
