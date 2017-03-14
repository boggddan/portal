class Receipt < ApplicationRecord
  belongs_to :supplier_order
  belongs_to :institution

  has_many :receipt_products,
           -> { select( :id, :receipt_id, :product_id, :date, :count, :code, :name )
                                        .joins( :product ) }, dependent: :destroy
  #
  before_save :set_default_value

  def set_default_value
    receipt = Receipt.select(:number).where( institution_id: institution_id ).last
    if receipt
      number = receipt.number.to_i + 1
    else
      number = 1
    end

    self.invoice_number ||= ''
    self.number ||= number.to_s.rjust(12, '0')
    self.date ||= Date.today
  end

end
