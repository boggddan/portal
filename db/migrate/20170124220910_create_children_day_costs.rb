class CreateChildrenDayCosts < ActiveRecord::Migration[5.0]
  def change
    create_table :children_day_costs do |t|
      t.belongs_to :children_category, foreign_key: true
      t.date :cost_date
      t.decimal :cost, precision: 8, scale: 2

      t.timestamps
    end
    add_index :children_day_costs, :cost_date
  end
end
