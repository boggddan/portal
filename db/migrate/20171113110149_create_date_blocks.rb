class CreateDateBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :date_blocks, comment: 'Дата блокування документів' do | t |
      t.belongs_to :institution, foreign_key: { on_delete: :cascade }, null: false, comment: 'Підрозділ'
      t.date :date, null: false, default: -> { 'CURRENT_TIMESTAMP' }, comment: 'Дата'

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }

      t.index [ :institution_id, :date ], name: :institution_id_date, unique: true
    end

    reversible do |direction|
      direction.up {
        execute <<-SQL.squish
            CREATE TRIGGER date_blocks_update_at
              BEFORE UPDATE ON date_blocks
                FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp()
          SQL
      }
    end
  end
end
