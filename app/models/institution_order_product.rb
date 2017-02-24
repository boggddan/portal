class InstitutionOrderProduct < ApplicationRecord
  belongs_to :institution_order
  belongs_to :product
end
