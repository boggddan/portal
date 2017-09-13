class InstitutionsDishesProduct < ApplicationRecord
  belongs_to :institution
  belongs_to :dish
  belongs_to :product
end
