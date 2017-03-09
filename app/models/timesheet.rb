class Timesheet < ApplicationRecord
  belongs_to :branch
  belongs_to :institution

  has_many :timesheet_dates, dependent: :destroy

  #
  before_save :set_default_value

  def set_default_value
    timesheet = Timesheet.select( :number ).where( institution_id: institution_id ).last
    if timesheet
      number = timesheet.number.to_i + 1
    else
      number = 1
    end

    self.number ||= number.to_s.rjust(12, '0')
    self.date ||= Date.today
  end
end
