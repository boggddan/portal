class AddPriorityToChildrenCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :children_categories, :priority, :integer, limit: 2, default: 0
    add_index :children_categories, :priority
  end
end
