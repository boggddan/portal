class CreateIoCorrectionProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :io_correction_products do |t|
      t.belongs_to :io_correction, foreign_key: true
      t.belongs_to :product, foreign_key: true
      t.date :date
      t.decimal :diff, precision: 8, scale: 3
      t.string :description, limit: 100

      t.timestamps
    end
    add_index :io_correction_products, :date
  end
end
