class CreateChildrenCategoriesTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :children_categories_types do |t|
      t.string :code, limit: 9
      t.string :name, limit: 50

      t.timestamps
    end
    add_index :children_categories_types, :code
  end
end
