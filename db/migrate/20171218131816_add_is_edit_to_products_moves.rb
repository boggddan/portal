class AddIsEditToProductsMoves < ActiveRecord::Migration[5.1]
  def change
    add_column :products_moves, :is_edit, :boolean, default: true, null: false, comment: 'Режим редагування'
  end
end
