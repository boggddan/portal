class AddTriggerProductsMoves < ActiveRecord::Migration[5.1]
  def change

    reversible do | direction |
      direction.up {
        execute <<-SQL
            CREATE OR REPLACE FUNCTION products_moves_to_intitution_id( ) RETURNS trigger AS $$
                -- Функция установки сада получателя по текущему саду
                BEGIN
                  NEW.to_institution_id := NEW.institution_id;
                  RETURN NEW;
                END;
              $$ LANGUAGE plpgsql;

            CREATE TRIGGER products_moves_to_intitution_id
              BEFORE INSERT ON products_moves
                FOR EACH ROW
                  -- Триггер срабатывает только при наличии подразделения и отсуствии номера документа
                  WHEN ( NEW.institution_id IS NOT NULL AND NEW.to_institution_id IS NULL )
                EXECUTE PROCEDURE products_moves_to_intitution_id( );
          SQL
      }

      # rollback
      direction.down {
        execute <<-SQL.squish
            DROP TRIGGER IF EXISTS products_moves_to_intitution_id ON products_moves CASCADE;
            DROP FUNCTION IF EXISTS products_moves_to_intitution_id( ) CASCADE;
          SQL
      }
    end
  end

end
