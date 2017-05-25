class ChangeFieldCodeFromBranches < ActiveRecord::Migration[5.0]
  def change
    change_column :branches, :code, :string, limit: 11
  end
end
