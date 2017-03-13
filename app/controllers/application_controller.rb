class ApplicationController < ActionController::Base
  before_action :verify_log_in # Фильтр на проверку зарегистрированости пользователя
  helper_method :day_of_week, :year_month_names, :short_day_of_week
  helper_method :current_user, :date_str, :f3_to_s, :f2_to_s

  $ghSavon = { wsdl: Rails.env.production? ?
    'http://192.168.1.2:8080/gos_release/ws/createsd.1cws?wsdl' :
    'http://192.168.1.2:8080/gos_release/ws/createsd.1cws?wsdl',
               namespaces: { 'xmlns:ins0' => 'http://www.reality.sh' } }

  def verify_log_in # Переход на страничку ввод логина и пароля, если не был произведен вход
    redirect_to log_in_path unless current_user
  end

  def verify_admin
    redirect_root unless current_user_type == 'Admin'
  end

  def verify_institution
    redirect_root unless current_user_type == 'Institution'
  end

  def index
    redirect_root
  end

  def redirect_root
    puts current_user_type
    if current_user_type == 'Admin'
      redirect_to admin_users_index_path
    else
      redirect_to institution_institution_orders_index_path
    end
  end

  def day_of_week( wday )
    { 0 => "Неділя", 1 => "Понеділок", 2 => "Вівторок", 3 => "Середа", 4 => "Четвер", 5 => "П'ятниця", 6 => "Субота" }[ wday ]
  end

  def short_day_of_week( wday )
    { 0 => "Нд", 1 => "Пн", 2 => "Вт", 3 => "Ср", 4 => "Чт", 5 => "Пт", 6 => "Сб" }[ wday ]
  end

  def month_names( month )
    { 1 => "Січень", 2 => "Лютий", 3 => "Березень", 4 => "Квітень", 5 => "Травень", 6 => "Червень",
      7 => "Липень", 8 => "Серпень", 9 => "Вересень", 10 => "Жовтень", 11 => "Лиспопад", 12 => "Грудень"}[ month ]
  end

  def year_month_names( date )
    "#{month_names( date.month )} #{date.year} р."
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

  def f3_to_s( value )
    ActionController::Base.helpers.number_with_precision( value, precision: 3 ) if value && value.nonzero?
  end

  def f2_to_s( value )
    ActionController::Base.helpers.number_with_precision( value, precision: 2 ) if value && value.nonzero?
  end

  def date_int_to_str( date )
    Time.at( date.to_i ).strftime( '%Y-%m-%d' )
  end

  def product_code( code )
    code = code.strip
    if product = Product.find_by( code: code )
      product
    else
      { error: { product: "Не знайдений код продукту [#{ code }]" } }
    end
  end

  def child_code( code )
    code = code.strip
    if child = Child.find_by( code: code )
      child
    else
      { error: { child: "Не знайдений код дитини [#{ code }]" } }
    end
  end

  def reasons_absence_code( code )
    code = code.strip
    if reasons_absence = ReasonsAbsence.find_by( code: code )
      reasons_absence
    else
      { error: { reasons_absence: "Не знайдений код причини відсутності [#{ code }]" } }
    end
  end

  def children_group_code( code )
    code = code.strip
    if children_group = ChildrenGroup.find_by( code: code )
      children_group
    else
      { error: { children_group:  "Не знайдений код дитячої группи [#{ code }]" } }
    end
  end

end
