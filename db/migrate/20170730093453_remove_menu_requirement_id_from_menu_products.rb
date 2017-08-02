class RemoveMenuRequirementIdFromMenuProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :menu_products, :menu_requirement_id
  end
end
