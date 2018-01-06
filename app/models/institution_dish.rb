class InstitutionDish < ApplicationRecord
  belongs_to :institutions
  belongs_to :dishes
  has_many   :dishes_products
end
