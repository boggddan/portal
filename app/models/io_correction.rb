class IoCorrection < ApplicationRecord
  belongs_to :institution_order

  has_many :io_correction_products, -> { select( :id, :io_correction_id, :product_id, :date, :diff, :description, :code, :name ).joins( :product ) }

  #
  before_save :set_default_value

  def set_default_value
    io_correction = IoCorrection.select(:number).where(institution_order_id: institution_order_id).last
    if io_correction
      number = io_correction.number.to_i + 1
    else
      number = 1
    end

    self.number ||= number.to_s.rjust(12, '0')
    self.date ||= Date.today
  end

end
