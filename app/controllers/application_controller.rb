class ApplicationController < ActionController::Base
  include CheckDbController

  helper_method :current_user, :date_str

  def get_savon( method_name, message )
    response = Savon.client( SAVON )
                 .call( method_name, message: message )
                 .body[ "#{ method_name }_response".to_sym ][ :return ]

    web_service = { call: { savon: SAVON, method: method_name.to_s.camelize, message: message } }

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
      sql = "UPDATE #{ table } SET " +
        data
          .merge!( updated_at: Time.now.to_s( :db ) )
          .map { | k, v | "#{ k }=#{ ['String', 'Date' ].include?( v.class.name ) ? "'#{ v }'" : v }" }
          .join( ',' ) +
        " WHERE id = #{ id }"
      ActiveRecord::Base.connection.execute( sql )

      result = true
    else
      result = false
    end
  end

  # def insert_base_single( table, data )
  #   if data.present?
  #     now = Time.now.to_s( :db )
  #     data.merge!( { created_at: now, updated_at: now } )

  #     fields = data.map { | k, v | k }.join( ',' )
  #     values = data.map { | k, v | [ 'String', 'Date' ].include?( v.class.name ) ? "'#{ v }'" : v }
  #       .join( ',' )

  #     sql = "INSERT INTO #{ table } (#{ fields }) VALUES (#{ values }) RETURNING *"
  #     record = JSON.parse( ActiveRecord::Base.connection.execute( sql )
  #       .to_json, symbolize_names: true )

  #     id = record[ 0 ]
  #     puts id
  #   else
  #     id = -1
  #   end
  # end

  # def number_next( table, where )
  #   sql = "SELECT number FROM #{ table }" +
  #     "WHERE "+
  #       where.map { | k, v | "#{ k }=#{ ['String', 'Date' ].include?( v.class.name ) ? "'#{ v }'" : v }" }
  #     "ORDER BY id DESC LIMIT 1"

  #     record = JSON.parse( ActiveRecord::Base.connection.execute( sql )
  #       .to_json, symbolize_names: true )


  #     prefix = institution.prefix.strip
  #   prefix_length = prefix.length


  #   record_last = institution.try( model_name.table_name ).select( :number ).last

  #   number = record_last.number if record_last.number.to( prefix_length - 1 ) == prefix if record_last

  #   ( number ||= "#{ prefix }-#{ '0'.rjust(model_name.type_for_attribute( 'number' ).limit - prefix_length - 1, '0' ) }" ).succ
  # end
end
