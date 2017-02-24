class InstitutionOrder < ApplicationRecord
  #
  belongs_to :institution

  has_many :io_corrections
  has_many :institution_order_products, -> { select( :id, :institution_order_id, :product_id, :date, :count, :description, :code, :name ).joins( :product ) }

  #
  before_save :set_default_value

  def set_default_value
    institution_order = InstitutionOrder.select(:number).where( institution_id: self.institution_id ).last
    if institution_order
      number = institution_order.number.to_i + 1
    else
      number = 1
    end

    self.number ||= number.to_s.rjust(12, '0')
    self.date ||= self.date_start ||=  self.date_end ||= Date.today
  end
end
