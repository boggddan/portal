class MenuChildrenCategory < ApplicationRecord
  belongs_to :menu_requirement
  belongs_to :children_category
end
