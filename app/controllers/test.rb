# require 'awesome_print'
# require 'json'
# require 'active_support/core_ext/string'

# ts_data = JSON.parse( File.read( 'file_ts' ), symbolize_names: true )
# timesheet_dates = JSON.parse( File.read( 'file_td' ), symbolize_names: true )
# children = JSON.parse( File.read( 'file_c' ), symbolize_names: true )
# children_groups = JSON.parse( File.read( 'file_cg' ), symbolize_names: true )
# reasons_absences = JSON.parse( File.read( 'file_ra' ), symbolize_names: true )

# reasons_absence_id_empty = 1

# sql_ins_val = ''
# sql_update = ''

# id = 1229
# ts_data.each { | ts |
#   children_group_id = children_groups[ :obj ][ ( ts[ :children_group_code ] || '' ).strip.to_sym ]
#   child_id = children[ :obj ][ ( ts[ :child_code ] || '' ).strip.to_sym ]
#   reasons_absence_id = reasons_absences[ :obj ][ ( ts[ :reasons_absence_code ] || '' ).strip.to_sym ]
#   date = ts[ :date ]

#   child_day = timesheet_dates.select{ | o |
#     o[ :children_group_id ] == children_group_id &&
#     o[ :child_id ] == child_id &&
#     o[ :date ] == date }

#   unless child_day.present?
#     sql_ins_val += ",(#{ id },#{ children_group_id },#{ child_id },#{ reasons_absence_id },'#{ date }')"
#   else
#     child_day[ 0 ][ :update ] = true
#     ( sql_update << <<-SQL.squish
#         UPDATE SET timesheet_dates
#           SET reasons_absence_id = #{ reasons_absence_id }
#           WHERE id = child_day[ :id ];
#       SQL
#     ) if reasons_absence_id != reasons_absence_id_empty && child_day[ 0 ][ :reasons_absence_id ] != reasons_absence_id
#   end
# }

# sql_insert = ''
# if sql_ins_val.present?
#   fields = %w( timesheet_id children_group_id child_id reasons_absence_id date ).join( ',' )
#   sql_insert = <<-SQL.squish
#       INSERT INTO timesheet_dates ( #{ fields } ) VALUES #{ sql_ins_val[1..-1] };
#     SQL
# end

# sql_del_val = timesheet_dates.select { | o | o[ :update].nil? }.map{ | o | o[ :id ] }.join( ',' )

# sql_delete = sql_del_val.present? ?
#   <<-SQL.squish
#       DELETE FROM timesheet_dates WHERE id IN ( #{ sql_del_val } );
#     SQL
#   : ''

# sql = sql_insert + sql_update + sql_delete
# #ActiveRecord::Base.connection.execute( sql )

# result = { status: true }
# result = { status: false, message: sql }

# p result


# dd = [ {dd: 1}]

# p dd.select{ |o| o[:dd] ==2 }
