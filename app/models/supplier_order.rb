class SupplierOrder < ApplicationRecord
  belongs_to :branch
  belongs_to :supplier

  has_many :supplier_order_products, dependent: :destroy
  has_many :receipts, dependent: :destroy
end
