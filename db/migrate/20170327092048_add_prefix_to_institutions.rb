class AddPrefixToInstitutions < ActiveRecord::Migration[5.0]
  def change
    add_column :institutions, :prefix, :string, limit: 3, default: ''
  end
end
