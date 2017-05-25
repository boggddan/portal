class ChangeColumnCodeFromInstitutions < ActiveRecord::Migration[5.0]
  def change
    change_column :institutions, :code, 'integer USING (code::integer)', precision: 9
  end
end
