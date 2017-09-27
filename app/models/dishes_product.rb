class DishesProduct < ApplicationRecord
  belongs_to :institution
  belongs_to :dish
  belongs_to :product
  has_many   :dishes_products_norms
end
