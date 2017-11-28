class CreateProductsMoves < ActiveRecord::Migration[5.1]
  def change
    create_table :products_moves, comment: 'Переміщення продуктів між садами' do | t |
      t.belongs_to :institution, foreign_key: { on_delete: :cascade }, null: false, comment: 'Підрозділ'
      t.belongs_to :to_institution, foreign_key: { to_table: :institutions, on_delete: :cascade }, null: false, comment: 'Підрозділ приймач'

      t.string :number, limit: 12, null: false, default: '', comment: 'Номер документа'
      t.date :date, null: false, default: -> { 'CURRENT_TIMESTAMP' }, comment: 'Дата документа'

      t.string :number_sa, limit: 12, null: false, default: '', comment: 'Номер документа ІС'
      t.date :date_sa, null: false, default: -> { 'CURRENT_TIMESTAMP' }, comment: 'Дата документа ІС'

      t.boolean :is_confirmed, null: false, default: false, comment: 'Ознака підтвердження переміщення'
      t.boolean :is_del_1c, null: false, default: false, comment:  'Ознака видалення ІС'

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }

      t.index :number
      t.index :date
    end

    change_column_comment( :products_moves, :id, 'Унікальний ідентифікатор' )
    change_column_comment( :products_moves, :created_at, 'Дата створення запису' )
    change_column_comment( :products_moves, :updated_at, 'Дата останнього оновлення запису' )

    reversible do | direction |
      direction.up {
        execute <<-SQL.squish
            CREATE TRIGGER institution_move_number
              BEFORE INSERT ON products_moves
                FOR EACH ROW
                  WHEN ( NEW.institution_id IS NOT NULL AND ( NEW.number IS NULL OR NEW.number = '' ) )
                EXECUTE PROCEDURE doc_number();

            CREATE TRIGGER products_moves_update_at
              BEFORE UPDATE ON products_moves
                FOR EACH ROW EXECUTE PROCEDURE update_at_timestamp();
          SQL
      }

    end

  end
end
