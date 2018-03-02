class Institution < ApplicationRecord
  belongs_to :branch
  has_many   :children_groups
  has_many   :supplier_order_products
  has_many   :receipts
  has_many   :menu_requirements
  has_many   :institution_orders
  has_many   :timesheets
  has_many   :suppliers_packages
  has_many   :dishes_products_norms
  has_many   :date_blocks
  has_many   :timesheet_date_blocks
  has_many   :institution_moves
  has_many   :institution_dishes
  has_many   :users, as: :userable, source_type: 'Institution'

  scope :select_name, -> { select( :id, :name ) }
  scope :kindergarten, -> { where( institution_type_code: 1 ) }
  scope :school, -> { where( institution_type_code: 2 ) }
  scope :order_name, -> { order( name: :asc ) }

end
