class TimesheetDate < ApplicationRecord
  belongs_to :timesheet
  belongs_to :children_group
  belongs_to :child
  belongs_to :reasons_absence
end
