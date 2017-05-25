class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def number_next( model_name, institution_id )
    institution = Institution.find( institution_id )
    prefix = institution.prefix.strip
    prefix_length = prefix.length

    record_last = institution.try( model_name.table_name ).select( :number ).last

    number = record_last.number if record_last.number.to( prefix_length - 1 ) == prefix if record_last

    ( number ||= "#{ prefix }-#{ '0'.rjust(model_name.type_for_attribute( 'number' ).limit - prefix_length - 1, '0' ) }" ).succ
  end

end
