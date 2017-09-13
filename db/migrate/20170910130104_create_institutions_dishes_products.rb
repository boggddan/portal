class CreateInstitutionsDishesProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :institutions_dishes_products, comment: 'Продукти в стравах підрозділу' do |t|
      t.belongs_to :institution, foreign_key: { on_delete: :cascade }, null: false, comment: 'Підрозділ'
      t.belongs_to :dish, foreign_key: { on_delete: :cascade } , null: false, comment: 'Довідник страв'
      t.belongs_to :product, foreign_key: { on_delete: :cascade }, null: false, comment: 'Довідник продуктів'
      t.boolean :enabled, default: false, comment: 'Відображення продукту при стравах підрозділу'

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }

      t.index [ :institution_id, :dish_id, :product_id ], name: :institution_dish_product, unique: true
    end

    reversible do |direction|
      direction.up {
        execute <<-SQL.squish
            CREATE TRIGGER institutions_dishes_products_update_at
              BEFORE UPDATE ON institutions_dishes_products
                FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp()
          SQL
      }
    end

  end

end
