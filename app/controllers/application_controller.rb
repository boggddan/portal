class ApplicationController < ActionController::Base
  include CheckDbController

  helper_method :current_user, :date_str

  def get_savon( method_name, message )
    response = Savon.client( SAVON )
                 .call( method_name, message: message )
                 .body[ "#{ method_name }_response".to_sym ][ :return ]

    name_camelize = method_name.to_s.camelize
    web_service = { call: { savon: SAVON, method: name_camelize, message: message } }

    File.open( "./public/web_send/#{ name_camelize }.txt", 'a' ) { | f |
      f.write( "\n *** #{ Time.now} ***#{ web_service.merge!( response: response ).to_json }" )
    }

    { response: response, web_service: web_service }
  end

  def current_user # Текущий пользователь
    @current_user ||= JSON.parse( User
      .select( :id, :username, :userable_type, :userable_id )
      .find( session[ :user_id ] )
      .to_json( methods: [ :is_admin?, :is_institution? ] ),
    symbolize_names: true ) if session[ :user_id ]
  end

  def date_str( date )
    date.strftime( '%d.%m.%Y' ) if date
  end

  def date_int_to_str( date )
    Time.at( date.to_i ).strftime( '%Y-%m-%d' )
  end

  def update_base_with_id( table, id, data )
    if id && data.present?
      values = data
        .map { | k, v | "#{ k }=#{ add_quotes( v ) }" }
        .join( ',' )

      sql = <<-SQL
          UPDATE #{ table } SET #{ values } WHERE id = #{ id }
        SQL

      ActiveRecord::Base.connection.execute( sql )

      result = true
    else
      result = false
    end
  end

  def add_quotes( value )
    [ 'String', 'Date' ].include?( value.class.name ) ? "'#{ value }'" : value
  end

  def check_date_block( date_start, date_end = nil )
    where = date_end.present? ? { date: date_start..date_end } : { date: date_start }
    DateBlock.select( :date ).where( where ).pluck( :date ).map{ | o | o.strftime( '%d.%m.%Y' ) }.join( ',' )
  end

  def insert_base_single( table, data )
    if data.present?
      fields = data.keys.join( ',' )
      values = data.map { | _, v | add_quotes( v ) }.join( ',' )

      sql = <<-SQL
          INSERT INTO #{ table } (#{ fields }) VALUES (#{ values }) RETURNING id
        SQL

      JSON.parse( ActiveRecord::Base.connection.execute( sql )
        .to_json, symbolize_names: true )[ 0 ][ :id ]
    else
      nil
    end
  end
end
