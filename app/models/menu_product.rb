class MenuProduct < ApplicationRecord
  belongs_to :children_category
  belongs_to :product
  belongs_to :menu_meals_dish

  has_many :price_products, through: :product
end
