class Receipt < ApplicationRecord
  belongs_to :supplier_order
  belongs_to :institution

  has_many :receipt_products, dependent: :destroy
  #
  before_save :set_default_value

  def set_default_value
    self.invoice_number ||= ''
    self.number ||= number_next( self.class, institution_id )
    self.date ||= Date.today
  end

end
