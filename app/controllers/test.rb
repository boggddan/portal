require 'json'
require 'awesome_print'


ts = JSON.parse( File.read( 'file_ts' ), symbolize_names: true )
td = JSON.parse( File.read( 'file_td' ), symbolize_names: true )

date = '2017-07-20'

child_ts = ts.select { | o | o[ :child_code ] == '3036374' and o[:date] == date }
child_td = td.select { | o | o[ :child_id ] == 14711 and o[:date] == date }

p child_ts, child_td
