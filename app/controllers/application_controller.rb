class ApplicationController < ActionController::Base
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

  def product_code( code )
    code = code.nil? ? '' : code.strip
    if product = Product.find_by( code: code )
      product
    else
      { error: { product: "Не знайдений код продукту [#{ code }]" } }
    end
  end

  def child_code( code )
    code = code.nil? ? '' : code.strip
    if child = Child.find_by( code: code )
      child
    else
      { error: { child: "Не знайдений код дитини [#{ code }]" } }
    end
  end

  def reasons_absence_code( code )
    code = code.nil? ? '' : code.strip
    if reasons_absence = ReasonsAbsence.find_by( code: code )
      reasons_absence
    else
      { error: { reasons_absence: "Не знайдений код причини відсутності [#{ code }]" } }
    end
  end

  def children_group_code( code )
    code = code.nil? ? '' : code.strip
    if children_group = ChildrenGroup.find_by( code: code )
      children_group
    else
      { error: { children_group:  "Не знайдений код дитячої группи [#{ code }]" } }
    end
  end

  def causes_deviation_code( code )
    code = code.nil? ? '' : code.strip
    if causes_deviation = CausesDeviation.find_by( code: code )
      causes_deviation
    else
      { error: { causes_deviation: "Не знайдений код причини відхилення [#{ code }]" } }
    end
  end

end
