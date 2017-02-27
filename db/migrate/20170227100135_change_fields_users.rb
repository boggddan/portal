class ChangeFieldsUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :institution_id
    remove_column :users, :supplier_id
    add_reference :users, :userable, polymorphic: true
  end
end
