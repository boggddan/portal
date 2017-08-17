class AddDocNumberTrigger < ActiveRecord::Migration[5.1]
  def change
    reversible do |direction|
      direction.up {
        triggers = %w( institution_orders receipts menu_requirements timesheets ).map { | table |
          <<-SQL
            CREATE TRIGGER #{ table }_number
              BEFORE INSERT ON #{ table }
                FOR EACH ROW
                  -- Триггер срабатывает только при наличии подразделения и отсуствии номера документа
                  WHEN ( NEW.institution_id IS NOT NULL AND ( NEW.number IS NULL OR NEW.number = '' ) )
                EXECUTE PROCEDURE doc_number();
          SQL
        }.join( '' )

        execute <<-SQL
          CREATE OR REPLACE FUNCTION doc_number() RETURNS trigger AS $$
            -- Функция генерации номера документа в разрезе подразделения и префикса у автоинкриментым увеличением
            DECLARE
              _prefix varchar := '';
              _number_prev varchar := '';
              _index_cur integer := 1;
              _lenght_number integer := 0;
              _sql_prev text := '';
            BEGIN
              -- Размер поля что бы сформировать правильное количество итоговых символов
              _lenght_number = ( SELECT aa.character_maximum_length FROM INFORMATION_SCHEMA.COLUMNS aa
                                 WHERE aa.table_name = TG_TABLE_NAME AND column_name = 'number' );
              -- Таблица "io_corrections" нумерация в разрезе таблицы заявок
              IF TG_TABLE_NAME = 'io_corrections' THEN
                -- Префикс с таблицы подразделений
                _prefix := ( SELECT bb.prefix FROM institution_orders aa
                             LEFT JOIN institutions bb ON bb.id = aa.institution_id
                             WHERE aa.id = NEW.institution_order_id );
                -- Последнее (максимальное) значения по подразделению и префиксе (префикс могут поменять, а потом вернуть обратно)
                _sql_prev := format( 'SELECT MAX(aa.number) FROM %s aa WHERE aa.institution_order_id = %s AND aa.number ~ %L',
                                     TG_TABLE_NAME, NEW.institution_order_id, _prefix );
              ELSE
                -- Префикс с таблицы подразделений
                _prefix := ( SELECT aa.prefix FROM institutions aa WHERE aa.id = NEW.institution_id );
                -- Последнее (максимальное) значения по подразделению и префиксе (префикс могут поменять, а потом вернуть обратно)
                _sql_prev := format( 'SELECT MAX(aa.number) FROM %s aa WHERE aa.institution_id = %s AND aa.number ~ %L',
                                     TG_TABLE_NAME, NEW.institution_id, _prefix );
              END IF;

              _prefix := trim( _prefix ) || '-' ;
              EXECUTE _sql_prev INTO _number_prev;
              -- Если найдено значенние
              IF _number_prev IS NOT NULL THEN
                -- Вырезаем из подстроки регулярным выражение цифровой номер и + 1
                _index_cur = ( regexp_matches( _number_prev, '-([0-9]*)$' ) )[ 1 ]::integer + 1;
              END IF;
              -- Отформатированный префиксом и ледирующими нулzvb номер размером на все поле, пример "KL-000000060"
              NEW.number := _prefix || to_char( _index_cur, 'FM' || repeat( '0', _lenght_number - length( _prefix ) ) );
              RETURN NEW;

            END;
          $$ LANGUAGE plpgsql;

          -- Корректировка заявки
          CREATE TRIGGER io_correction_number
            BEFORE INSERT ON io_corrections
              FOR EACH ROW
                -- Триггер срабатывает только при наличии заявки и отсуствии номера документа
                WHEN ( NEW.institution_order_id IS NOT NULL AND ( NEW.number IS NULL OR NEW.number = '' ) )
              EXECUTE PROCEDURE doc_number();

          #{ triggers }
        SQL
      }

      # rollback
      direction.down {
        execute <<-SQL
          DROP FUNCTION IF EXISTS doc_number() CASCADE;
        SQL
      }
    end
  end
end
