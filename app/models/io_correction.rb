class IoCorrection < ApplicationRecord
  belongs_to :institution_order

  has_one :institution, through: :institution_order

  has_many :io_correction_products, dependent: :destroy

  #
  before_save :set_default_value

  def set_default_value
    institution_id = InstitutionOrder.find(institution_order_id ).institution_id
    self.number ||= number_next( self.class, institution_id )
    self.date ||= Date.today
  end

end
