class MenuProductsPrice < ApplicationRecord
  belongs_to :menu_requirement
  belongs_to :product
end
