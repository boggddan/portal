class Receipt < ApplicationRecord
  belongs_to :supplier_order
  belongs_to :institution
  has_many   :receipt_products
end
