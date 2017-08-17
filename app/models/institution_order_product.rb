class InstitutionOrderProduct < ApplicationRecord
  belongs_to :institution_order
  belongs_to :product
  has_many   :iop_packages
end
