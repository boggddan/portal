  def number_next( table, where )
    sql = "SELECT number FROM #{ table }" +
      "WHERE "+
        where.map { | k, v | "#{ k }=#{ ['String', 'Date' ].include?( v.class.name ) ? "'#{ v }'" : v }" }
      "ORDER BY id DESC LIMIT 1"

    number = JSON.parse( ActiveRecord::Base.connection.execute( number )
      .to_json, symbolize_names: true )


    prefix = institution.prefix.strip
    prefix_length = prefix.length


    record_last = institution.try( model_name.table_name ).select( :number ).last

    number = record_last.number if record_last.number.to( prefix_length - 1 ) == prefix if record_last

    ( number ||= "#{ prefix }-#{ '0'.rjust(model_name.type_for_attribute( 'number' ).limit - prefix_length - 1, '0' ) }" ).succ
  end
