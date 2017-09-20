class DishesProductsNorm < ApplicationRecord
  belongs_to :institution
  belongs_to :dish
  belongs_to :product
  belongs_to :children_category
end
