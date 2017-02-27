class ApplicationController < ActionController::Base
  before_action :verify_log_in # Фильтр на проверку зарегистрированости пользователя
  helper_method :day_of_week, :year_month_names
  helper_method :current_user, :date_str, :f3_to_s, :f2_to_s

  $ghSavon = { wsdl: 'http://192.168.1.2:8080/gos1_new/ws/createsd.1cws?wsdl',
               namespaces: { 'xmlns:ins0' => 'http://www.reality.sh' } }

  #$ghSavon = { wsdl: "http://77.123.138.82:999/edu/ws/createsd.1cws?wsdl",  namespaces: { "xmlns:ins0" => 'http://www.reality.sh' } }

 
  #comment11 bogdan

  #comment15 reality

  #comment12 bogdan

  #comment16 reality

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
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_institution # Текущее подразделение
    current_user.institution
  end

  def current_branch # Текущий отдел
    current_institution.branch
  end

  def product_code( code )
    if product = Product.find_by( code: code )
      product
    else
      { error: { product: "Не знайдений код продукту [#{code}]" } }
    end
  end

  def date_str(date)
    date.strftime('%d.%m.%Y') if date
  end

  def f3_to_s(value)
    ActionController::Base.helpers.number_with_precision( value, precision: 3 ) if value && value.nonzero?
  end

  def f2_to_s(value)
    ActionController::Base.helpers.number_with_precision( value, precision: 2 ) if value && value.nonzero?
  end

  def date_int_to_str(date)
    Time.at(date.to_i).strftime('%Y-%m-%d')
  end

  def verify_log_in # Переход на страничку ввод логина и пароля, если не был произведен вход
    redirect_to log_in_path unless current_user
  end



end
