class InstitutionOrder < ApplicationRecord
  belongs_to :institution
  has_many   :io_corrections
  has_many   :institution_order_products
end
