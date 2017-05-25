class ChildrenGroup < ApplicationRecord
  belongs_to :institution
  belongs_to :children_category

  has_many :timesheet_dates
end
