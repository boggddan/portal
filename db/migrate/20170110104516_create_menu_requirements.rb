class CreateMenuRequirements < ActiveRecord::Migration[5.0]
  def change
    create_table :menu_requirements do |t|
      t.belongs_to :branch, foreign_key: true
      t.belongs_to :institution, foreign_key: true
      t.string :number, limit: 12
      t.date :date
      t.date :splendingdate
      t.date :date_sap
      t.date :date_saf

      t.timestamps
    end
    add_index :menu_requirements, :number
    add_index :menu_requirements, :date
  end
end
