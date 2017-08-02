class IoCorrectionProduct < ApplicationRecord
  belongs_to :io_correction
  belongs_to :product

  def diff_amount
    self.amount - self.amount_order
  end
end
