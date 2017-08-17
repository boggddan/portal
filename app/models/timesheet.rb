class Timesheet < ApplicationRecord
  belongs_to :branch
  belongs_to :institution
  has_many   :timesheet_dates
end
