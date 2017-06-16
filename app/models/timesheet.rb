class Timesheet < ApplicationRecord
  belongs_to :branch
  belongs_to :institution
  has_many :timesheet_dates, dependent: :destroy

  #
  before_save :set_default_value

  def set_default_value
    self.number ||= number_next( self.class, institution_id )
    self.date ||= Date.today
  end
end
