class AddInstitutionToChildrenGroups < ActiveRecord::Migration[5.0]
  def change
    add_reference :children_groups, :institution, foreign_key: true
  end
end
