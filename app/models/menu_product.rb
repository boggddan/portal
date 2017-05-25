class MenuProduct < ApplicationRecord
  belongs_to :menu_requirement
  belongs_to :children_category
  belongs_to :product

  has_many :price_products, through: :product
end
