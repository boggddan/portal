# # rails runner app/controllers/test.rb --environment=development

# require 'json'

#     def exists_codes( table, codes )
#       sql = "SELECT code, COALESCE( bb.id, -1 ) as id " +
#       "FROM UNNEST(ARRAY"+
#           codes.map { | o | o || '' }.to_s.gsub( '"', '\'' ) +
#         ") AS code " +
#       "LEFT JOIN #{ table } bb USING( code )"

#       obj = JSON.parse( ActiveRecord::Base.connection.execute( sql ).to_json, symbolize_names: true )
#       error_codes = obj.select { | o | o[ :id ] == -1 }.map{ | o | o[ :code ] }

#       { status: error_codes.empty?,
#         obj: obj.map { | o | { o[ :code ] => o[ :id ] } },
#         error: { table => "Не знайдені кода: #{ error_codes.to_s.gsub( '"', '\'' ) }" } }
#     end

# error = { }
# reasons_absences = exists_codes( 'reasons_absences', [ nil ,'000000001'] )

# puts reasons_absences

# error.merge!( reasons_absences[ :error ] ) unless reasons_absences[ :status ]
# puts reasons_absences[ :obj ]['000000001']

dd = [1..3]
puts 1 == 1..2

