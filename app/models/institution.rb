class Institution < ApplicationRecord
  belongs_to :branch

  has_many :supplier_order_products
  has_many :receipts
  has_many :menu_requirements
  has_many :institution_orders
  has_many :price_products
  has_many :timesheets

  has_many :users, as: :userable
end
