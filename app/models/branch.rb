class Branch < ApplicationRecord
  has_many :institutions
  has_many :supplier_orders
  has_many :menu_requirements
  # has_many :price_products
  has_many :timesheets
end
