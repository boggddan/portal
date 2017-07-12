Rails.application.routes.draw do

  scope module: :institution do
    root action: :index, controller: :base, constraints: RoleRouteConstraint.new( :is_institution? )
  end

  scope module: :admin do
    root action: :index, controller: :base, constraints: RoleRouteConstraint.new( :is_admin? )
  end

  root action: :log_in, controller: :sessions

  draw :api

  draw :institution

  draw :admin # Пользователи

  draw :sessions # Сесия
end

