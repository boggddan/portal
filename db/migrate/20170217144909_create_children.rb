class CreateChildren < ActiveRecord::Migration[5.0]
  def change
    create_table :children do |t|
      t.string :code, limit: 9
      t.string :name, limit: 250

      t.timestamps
    end
    add_index :children, :code
  end
end
