Rails.application.routes.draw do

  scope module: :institution do
    root action: :index, controller: :base, constraints: RoleRouteConstraint.new( :is_institution? )
  end

  #root action: :index, controller: 'institution/base', constraints: RoleRouteConstraint.new( :is_institution? )

  root action: :index, controller: 'admin/base', constraints: RoleRouteConstraint.new( :is_admin? )
  root action: :log_in, controller: :sessions

  draw :api

  draw :institution

  draw :admin # Пользователи

  draw :sessions # Сесия
end

