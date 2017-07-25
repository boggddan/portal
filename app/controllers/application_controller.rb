class ApplicationController < ActionController::Base
  include CheckDbController

  before_action :verify_log_in # Фильтр на проверку зарегистрированости пользователя
  helper_method :current_user, :date_str

  def verify_log_in # Переход на страничку ввод логина и пароля, если не был произведен вход
    redirect_to root_path unless current_user
  end

  def index
    #redirect_root
    #redirect_to root_path

  end

  def redirect_root
    #if current_user_type == 'Admin'
    #  redirect_to admin_index_path
    #else
    #  redirect_to institution_index_path
    #end
  end

  def current_user # Текущий пользователь
    @current_user ||= User.find_by( id: session[ :user_id ] )
  end

  def current_user_type # Текущий пользователь
    @current_user_type ||= current_user.userable_type
  end

  def date_str( date )
    date.strftime( '%d.%m.%Y' ) if date
  end

  def date_int_to_str( date )
    Time.at( date.to_i ).strftime( '%Y-%m-%d' )
  end


end
