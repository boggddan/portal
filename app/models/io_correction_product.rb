class IoCorrectionProduct < ApplicationRecord
  belongs_to :io_correction
  belongs_to :product

  #
  before_save :set_default_value

  def set_default_value
    self.diff ||= 0
  end

  def result
    self.count + self.diff
  end

end
