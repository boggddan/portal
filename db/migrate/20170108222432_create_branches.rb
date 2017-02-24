class CreateBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :branches do |t|
      t.string :code, limit: 4
      t.string :name, limit: 50

      t.timestamps
    end
    add_index :branches, :code
  end
end
