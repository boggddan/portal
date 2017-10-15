class CreateMenuProductsPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :menu_products_prices, comment: 'Ціна та залишок продукту в меню-вимозі' do |t|
      t.belongs_to :menu_requirement, foreign_key:  { on_delete: :cascade }, null: false, comment: 'Меню-вимога'
      t.belongs_to :product, foreign_key: { on_delete: :cascade }, null: false, comment: 'Довідник продуктів'
      t.decimal :price, precision: 15, scale: 5, default: 0, null: false, comment: 'Ціна'
      t.decimal :balance, precision: 8, scale: 3, default: 0, null: false, comment: 'Залишок продуктів'

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }

    end

    reversible do |direction|
      direction.up {
        execute <<-SQL.squish
            CREATE TRIGGER menu_products_prices_update_at
              BEFORE UPDATE ON menu_products_prices
                FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp()
          SQL
      }
    end

  end
end
