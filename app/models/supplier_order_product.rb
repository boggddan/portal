class SupplierOrderProduct < ApplicationRecord
  belongs_to :supplier_order
  belongs_to :institution
  belongs_to :product
end
