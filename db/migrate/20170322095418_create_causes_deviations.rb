class CreateCausesDeviations < ActiveRecord::Migration[5.0]
  def change
    create_table :causes_deviations do |t|
      t.string :code, limit: 9
      t.string :name, limit: 40

      t.timestamps
    end
    add_index :causes_deviations, :code
  end
end
