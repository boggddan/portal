class AddDishesProductsToDishesProductsNorm < ActiveRecord::Migration[5.1]
  def change
    table_name = :dishes_products_norms
    reversible do | direction |
      direction.up {
        execute <<-SQL.squish
            DELETE FROM #{ table_name }
          SQL
      }
    end

    change_table table_name do | t |
      t.belongs_to :dishes_product, foreign_key: { on_delete: :cascade }, null: false, comment: 'Продукти в стравах підрозділу'
      t.remove_belongs_to :institution, foreign_key: { on_delete: :cascade } , null: false, comment: 'Довідник підрозділів'
      t.remove_belongs_to :dish, foreign_key: { on_delete: :cascade } , null: false, comment: 'Довідник страв'
      t.remove_belongs_to :product, foreign_key: { on_delete: :cascade }, null: false, comment: 'Довідник продуктів'

      t.index [ :dishes_product_id, :children_category_id ], name: :dishes_product_id_children_category_id, unique: true
    end
  end
end
