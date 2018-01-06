class ChangeDataToDishesProducts < ActiveRecord::Migration[5.1]

  def change
    reversible do | direction |
      direction.up {
        execute <<-SQL.squish
            WITH
              new_institution_dishes( id ) AS (
                INSERT INTO institution_dishes ( institution_id, dish_id )
                  VALUES (
                    ( SELECT id FROM institutions WHERE code = 0 ) ,
                    ( SELECT id FROM dishes WHERE code = '' )
                  )
                  ON CONFLICT ( institution_id, dish_id )
                  DO UPDATE SET institution_id = EXCLUDED.institution_id
                  RETURNING id ),

                dishes_products_update AS (
                  UPDATE dishes_products SET
                    institution_dish_id = ( SELECT id FROM new_institution_dishes )
                    WHERE dish_id = 1 AND institution_id = 222
                  ),

                dishes_products_delete AS (
                  DELETE FROM dishes_products WHERE dish_id != 1 OR institution_id != 222
                 )
                SELECT id FROM new_institution_dishes
              SQL
        }
    end

    table_name = :dishes_products

    add_index table_name, [ :institution_dish_id, :product_id ], name: :institution_dish_id_product_id_children_category_id, unique: true
    change_column_null table_name, :institution_dish_id, false

    remove_reference table_name, :dish, index: true
    remove_reference table_name, :institution, index: true
    remove_column table_name, :enabled
  end
end
