class InstitutionOrder < ApplicationRecord
  #
  belongs_to :institution

  has_many :io_corrections, dependent: :destroy
  has_many :institution_order_products, dependent: :destroy
  #
  before_save :set_default_value

  def set_default_value
    self.number ||= number_next( self.class, institution_id )
    self.date ||= self.date_start ||=  self.date_end ||= Date.today
  end
end
