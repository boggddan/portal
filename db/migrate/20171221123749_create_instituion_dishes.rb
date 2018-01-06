class CreateInstituionDishes < ActiveRecord::Migration[5.1]
  def change
    create_table :institution_dishes, comment: 'Страви підрозділу' do |t|
      t.belongs_to :institution, foreign_key: { on_delete: :cascade }, null: false, comment: 'Підрозділ'
      t.belongs_to :dish, foreign_key: { on_delete: :cascade } , null: false, comment: 'Довідник страв'
      t.boolean :enabled, default: true, comment: 'Відображення страви в підрозділу'

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }

      t.index [ :institution_id, :dish_id ], name: :institution_id_dish_id, unique: true
    end

    reversible do |direction|
      direction.up {
        execute <<-SQL.squish
            CREATE TRIGGER institution_dishes_update_at
              BEFORE UPDATE ON institution_dishes
                FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp()
          SQL
      }
    end
  end
end
