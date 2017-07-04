class Institution < ApplicationRecord
  belongs_to :branch

  has_many :children_groups
  has_many :children_categories, -> { group( :id ).order( :code ) }, through: :children_groups
  has_many :supplier_order_products
  has_many :receipts
  has_many :menu_requirements
  has_many :institution_orders
  has_many :io_corrections, through: :institution_orders
  has_many :price_products
  has_many :timesheets
  has_many :suppliers_packages

  has_many :users, as: :userable
end
