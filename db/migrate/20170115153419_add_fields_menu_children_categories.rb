class AddFieldsMenuChildrenCategories < ActiveRecord::Migration[5.0]
  def change
    rename_column :menu_children_categories, :count_all, :count_all_plan
    rename_column :menu_children_categories, :count_exemption, :count_exemption_plan
    add_column :menu_children_categories, :count_all_fact, :decimal, precision: 8, scale: 2
    add_column :menu_children_categories, :count_exemption_fact, :decimal, precision: 8, scale: 2

    change_column_default :menu_children_categories, :count_all_plan, 0
    change_column_default :menu_children_categories, :count_exemption_plan, 0
    change_column_default :menu_children_categories, :count_all_fact, 0
    change_column_default :menu_children_categories, :count_exemption_fact, 0
  end
end
