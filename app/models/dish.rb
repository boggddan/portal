class Dish < ApplicationRecord
  belongs_to :dishes_category
  has_many   :menu_meals_dishes
  has_many   :dishes_products_norms
  has_many   :institutions_dishes_products
end
