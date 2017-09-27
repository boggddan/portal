class DishesProductsNorm < ApplicationRecord
  belongs_to :dishes_product
  belongs_to :children_category
end

