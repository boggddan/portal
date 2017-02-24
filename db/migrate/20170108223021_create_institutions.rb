class CreateInstitutions < ActiveRecord::Migration[5.0]
  def change
    create_table :institutions do |t|
      t.belongs_to :branch, foreign_key: true
      t.string :code, limit: 9
      t.string :name, limit: 50

      t.timestamps
    end
    add_index :institutions, :code
  end
end
