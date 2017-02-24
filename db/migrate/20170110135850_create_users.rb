class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.belongs_to :institution, foreign_key: true
      t.belongs_to :supplier, foreign_key: true
      t.string :username
      t.string :password_digest
      t.boolean :is_admin

      t.timestamps
    end
    add_index :users, :username
  end
end
