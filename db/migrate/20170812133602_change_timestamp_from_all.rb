class ChangeTimestampFromAll < ActiveRecord::Migration[5.1]
  def change
    tables = ActiveRecord::Base.connection.tables
      .delete_if { | v | [ 'ar_internal_metadata', 'schema_migrations' ].include?( v ) }

    tables.each { | table |
      change_column_default( table, :created_at, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
      change_column_default( table, :updated_at, from: nil, to: -> { 'CURRENT_TIMESTAMP' } )
    }

    reversible do |direction|
      triggers = tables.map { | table |
        "CREATE TRIGGER #{ table }_update_at " +
          "BEFORE UPDATE ON #{ table } " +
            "FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();"
      }.join('')

      direction.up {
        execute <<-SQL
          CREATE OR REPLACE FUNCTION update_at_timestamp() RETURNS trigger AS $$
            BEGIN
              NEW.updated_at := current_timestamp;
              RETURN NEW;
            END;
          $$ LANGUAGE plpgsql;

          #{ triggers }
        SQL
      }

      # rollback
      direction.down {
        execute <<-SQL
          DROP FUNCTION IF EXISTS update_at_timestamp() CASCADE;
        SQL
      }
    end

  end
end
