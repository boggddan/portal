class SupplierOrder < ApplicationRecord
  belongs_to :branch
  belongs_to :supplier
  has_many :supplier_order_products
  has_many :receipts
end
