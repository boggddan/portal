class CreateProductsMoveProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products_move_products, comment: 'Переміщення продуктів між садами таблична частина' do | t |
      t.belongs_to :products_move, foreign_key: { on_delete: :cascade }, null: false, comment: 'Переміщення продуктів між садами'
      t.belongs_to :product, foreign_key: { on_delete: :cascade }, null: false, comment: 'Довідник продуктів'
      t.decimal :amount, precision: 8, scale: 3, default: 0, null: false, comment: 'Кількість продуктів'

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    reversible do |direction|
      direction.up {
        execute <<-SQL.squish
            CREATE TRIGGER products_move_products_update_at
              BEFORE UPDATE ON products_move_products
                FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp()
          SQL
      }
    end

  end
end
