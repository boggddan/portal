class Supplier < ApplicationRecord
  has_many :supplier_orders
  has_many :users, as: :userable
end
