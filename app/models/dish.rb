class Dish < ApplicationRecord
  belongs_to :dishes_category
  has_many   :menu_meals_dishes

  validates :dishes_category_id, presence: true
end
