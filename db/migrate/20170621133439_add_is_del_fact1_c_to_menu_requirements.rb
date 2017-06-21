class AddIsDelFact1CToMenuRequirements < ActiveRecord::Migration[5.1]
  def change
    rename_column :menu_requirements, :is_del_1c, :is_del_plan_1c
    add_column :menu_requirements, :is_del_fact_1c, :boolean, default: false
  end
end
