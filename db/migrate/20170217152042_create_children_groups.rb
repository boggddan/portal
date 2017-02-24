class CreateChildrenGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :children_groups do |t|
      t.belongs_to :children_category, foreign_key: true
      t.string :code, limit: 9
      t.string :name, limit: 30

      t.timestamps
    end
    add_index :children_groups, :code
  end
end
