class ChildrenCategory < ApplicationRecord
  belongs_to :children_categories_type
  has_many :menu_children_categories
  has_many :menu_products

  has_many :children_day_costs
  has_many :children_groups
end
