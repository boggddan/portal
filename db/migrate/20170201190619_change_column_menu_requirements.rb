class ChangeColumnMenuRequirements < ActiveRecord::Migration[5.0]
  def change
    rename_column :menu_requirements, :number_plan, :number_sap
    rename_column :menu_requirements, :number_fact, :number_saf
  end
end
