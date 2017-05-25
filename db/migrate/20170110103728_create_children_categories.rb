class CreateChildrenCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :children_categories do |t|
      t.belongs_to :children_categories_type, foreign_key: true
      t.string :code, limit: 9
      t.string :name, limit: 50

      t.timestamps
    end
    add_index :children_categories, :code
  end
end
