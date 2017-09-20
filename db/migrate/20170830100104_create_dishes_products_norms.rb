class CreateDishesProductsNorms < ActiveRecord::Migration[5.1]
  def change
    create_table :dishes_products_norms, comment: 'Норми продуктів підрозділів в стравах по категоріях дітей' do |t|
      t.belongs_to :institution, foreign_key: { on_delete: :cascade } , null: false, comment: 'Довідник підрозділів'
      t.belongs_to :dish, foreign_key: { on_delete: :cascade } , null: false, comment: 'Довідник страв'
      t.belongs_to :product, foreign_key: { on_delete: :cascade }, null: false, comment: 'Довідник продуктів'
      t.belongs_to :children_category, foreign_key: { on_delete: :cascade }, null: false, comment: 'Довідник категорій дітей'
      t.decimal :amount, precision: 15, scale: 6, default: 0, comment: 'Кількість (норма) на 1 порцію'

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }

      t.index [ :institution_id, :dish_id, :product_id, :children_category_id ], name: :institution_dish_product_children_category, unique: true
    end

    reversible do |direction|
      direction.up {
        execute <<-SQL.squish
            CREATE TRIGGER dishes_products_norms_update_at
              BEFORE UPDATE ON dishes_products_norms
                FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp()
          SQL
      }
    end

  end
end
