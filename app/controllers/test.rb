require 'awesome_print'
require 'json'
require 'active_support/core_ext/string'

hash_data = JSON.parse( [ {id: 1, upd: false}, {id: 2, upd: false} ]
  .to_json( ), symbolize_names: true )

dd = hash_data.select{ |o| o[:id] == 1 }
dd[0][:upds] = 4
ap hash_data.select{ |o| o[:upds].nil?  }

#dd = 'fffddf'

#ap dd << 'aaaaaf'
