class AddFieldsMenuRequirements < ActiveRecord::Migration[5.0]
  def change
    add_column :menu_requirements, :number_plan, :string, limit: 12
    add_column :menu_requirements, :number_fact, :string, limit: 12
  end
end
