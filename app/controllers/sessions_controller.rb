class SessionsController < ApplicationController
  skip_before_action :verify_log_in # Отключение фильтра проверки пользователя

  def create # Создание входа в портал
    user = User.find_by_username( params[ :username ] )
    if user && user.authenticate( params[ :password ] )
      session[ :user_id ] = user.id
      redirect_to root_url
    else
      render :log_in
    end
  end

  def log_out # Выход пользователя
    @current_user = session[ :user_id ] = nil
    redirect_to root_url
  end

end
