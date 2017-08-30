class CreateDishesProductsNorms < ActiveRecord::Migration[5.1]
  def change
    create_table :dishes_products_norms, comment: 'Норми продуктів в стравах по категоріях дітей' do |t|
      t.belongs_to :dishes, foreign_key: true, null: false, comment: 'Довідник страв'
      t.belongs_to :products, foreign_key: true, null: false, comment: 'Довідник продуктів'
      t.belongs_to :children_categories, foreign_key: true, null: false, comment: 'Довідник категорій дітей'
      t.decimal :amount, precision: 15, scale: 6, default: 0, comment: 'Кількість (норма) на 1 порцію'

      t.timestamps
    end
  end
end
