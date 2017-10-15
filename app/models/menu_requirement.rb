class MenuRequirement < ApplicationRecord
  belongs_to :branch
  belongs_to :institution
  has_many   :menu_meals_dishes
  has_many   :menu_children_categories
  has_many   :menu_products_price
end
