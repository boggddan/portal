class MenuProduct < ApplicationRecord
  belongs_to :menu_requirement
  belongs_to :children_category
  belongs_to :product

  #scope :products, -> { select(:id, :children_category_id, :count_plan, :count_fact, 'count_fact - count_plan as count_diff').where(children_category_id: 8).joins(:product).select(:name, :code).order('products.name') }

  has_many :price_products, through: :product

  #def count_diff
 #   self.count_fact - self.count_plan
  #end

end
