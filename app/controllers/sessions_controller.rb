class SessionsController < ApplicationController
  skip_before_action :verify_log_in # Отключение фильтра проверки пользователя

  def log_in
  end  

  def create # Создание входа в портал
    user = User.find_by_username( params[ :username ] )
    if user && user.authenticate( params[ :password ] )
      session[ :user_id ] = user.id
      result = { status: true, href: root_url }
    else
      result = { status: false, caption: "Неправильне ім'я користувача чи пароль",
                 message: { username: params[ :username ], password: params[ :password ] } }
    end

    render json: result
  end

  def log_out # Выход пользователя
    @current_user = session[ :user_id ] = nil
    redirect_to root_url
  end

end
