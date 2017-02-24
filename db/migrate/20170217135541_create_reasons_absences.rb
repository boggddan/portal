class CreateReasonsAbsences < ActiveRecord::Migration[5.0]
  def change
    create_table :reasons_absences do |t|
      t.string :code, limit: 9
      t.string :mark, limit: 3
      t.string :name, limit: 30
      t.integer :priority, limit: 2

      t.timestamps
    end
    add_index :reasons_absences, :code
  end
end
