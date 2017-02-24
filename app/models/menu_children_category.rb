class MenuChildrenCategory < ApplicationRecord
  belongs_to :menu_requirement
  belongs_to :children_category

  #has_many :children_day_costs, through: :children_category


  has_many :products_categories, -> (object) { where(children_category_id: object.children_category_id).select(:id, :product_id, :count_fact, :count_plan, 'count_fact-count_plan as count_diff') },
           class_name: MenuProduct, through: :menu_requirement, source: :menu_products
end