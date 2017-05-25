class ChangePrefixFromInstitutions < ActiveRecord::Migration[5.0]
  def change
    change_column :institutions, :prefix, :string, limit: 4

  end
end
