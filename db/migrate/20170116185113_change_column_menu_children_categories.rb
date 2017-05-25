class ChangeColumnMenuChildrenCategories < ActiveRecord::Migration[5.0]
  def change
    change_column :menu_children_categories, :count_all_plan, :integer, limit: 4, :default => 0, :null => false
    change_column :menu_children_categories, :count_exemption_plan, :integer, limit: 4, :default => 0, :null => false
    change_column :menu_children_categories, :count_all_fact, :integer, limit: 4, :default => 0, :null => false
    change_column :menu_children_categories, :count_exemption_fact, :integer, limit: 4, :default => 0, :null => false
  end
end
