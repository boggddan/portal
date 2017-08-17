class IoCorrection < ApplicationRecord
  belongs_to :institution_order
  has_many   :io_correction_products
end
