class CreateMenuChildrenCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :menu_children_categories do |t|
      t.belongs_to :menu_requirement, foreign_key: true
      t.belongs_to :children_category, foreign_key: true
      t.decimal :count_all, precision: 8, scale: 2
      t.decimal :count_exemption, precision: 8, scale: 2

      t.timestamps
    end
  end
end
