current_institution = Institution.find_by( code: '14' )
current_branch = current_institution.branch
require 'json'
application = ApplicationController.new

date_start = '01.08.2017'.to_date
date_end = '31.08.2017'.to_date

# ts_data = JSON.parse( File.read( 'out' ), symbolize_names: true )
# response = {  interface_state: 'OK', date_vb: date_start, date_ve: date_end, date_eb: date_start, date_ee: date_end  }

message = { 'CreateRequest' => { 'StartDate' => date_start,
                                  'EndDate' => date_end,
                                  'Institutions_id' => current_institution.code } }
method_name = :get_data_time_sheet
response = Savon.client( SAVON )
              .call( method_name, message: message )
              .body[ "#{ method_name }_response".to_sym ][ :return ]

web_service = { call: { savon: SAVON, method: method_name.to_s.camelize, message: message } }

ts_data = response[ :ts ]

result = { }
if response[ :interface_state ] == 'OK' && ts_data && ts_data.present?
  error = [ ]

  children = { }
  ts_data.group_by { | o | o[ :child_code ] }.each { | k, v |
    child = application.child_code( k )
    if child[ :error ] then error << child[ :error ] else children.merge!( k => child.id ) end
  }

  children_groups = { }
  ts_data.group_by { | o | o[ :children_group_code ] }.each { | k, v |
    children_group = application.children_group_code( k +'1' )
    if children_group[ :error ] then error << children_group[ :error ] else children_groups.merge!( k => children_group.id ) end
  }

  reasons_absences = { }
  ts_data.group_by { | o | o[ :reasons_absence_code ] }.each { | k, v |
    reasons_absence = application.reasons_absence_code( k )
    if reasons_absence[ :error ] then error << reasons_absence[ :error ] else reasons_absences.merge!( k => reasons_absence.id ) end
  }

  if error.empty?
    ActiveRecord::Base.transaction do
      now = Time.now.to_s( :db )

      timesheet = Timesheet.create( institution: current_institution,
                                    branch: current_branch,
                                    date_vb: response[ :date_vb ],
                                    date_ve: response[ :date_ve ],
                                    date_eb: response[ :date_eb ],
                                    date_ee: response[ :date_ee ],
                                    date: now )
      id = timesheet.id

      fields = %w( timesheet_id children_group_id child_id reasons_absence_id
                  date created_at updated_at ).join( ',' )

      sql_values = ''

      ts_data.each { | ts |
        sql_values += ",(#{ id }," +
                      "#{ children_groups[ ts[ :children_group_code ] ] }," +
                      "#{ children[ ts[ :child_code ] ] }," +
                      "#{ reasons_absences[ ts[ :reasons_absence_code ] ] }," +
                      "'#{ ts[ :date ] }'," +
                      "'#{ now }','#{ now }')"
      }

      sql = "INSERT INTO timesheet_dates ( #{ fields } ) VALUES #{ sql_values[1..-1] }"

      file = File.new( 'out_sql', 'w' )
      file.write( sql )
      file.close
      ActiveRecord::Base.connection.execute( sql )

      # href = institution_timesheets_dates_path( { id: id } )
      href = { id: id }
      result = { status: true, href: href }
    end
  else
    result = { status: false, caption: 'Неможливо створити документ',
              message: { error: error }.merge!( web_service ) }
  end
else
  result = { status: false, caption: 'За вибраний період даних немає в 1С',
             message: web_service.merge!( response: response ) }
end

puts json: result
# render json: result
