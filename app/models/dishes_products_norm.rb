class DishesProductsNorm < ApplicationRecord
  belongs_to :dishesproducts
  belongs_to :children_categories
end
