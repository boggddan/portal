class MenuMealsDish < ApplicationRecord
  belongs_to :menu_requirement
  belongs_to :meal
  belongs_to :dish
  has_many   :menu_products
end
