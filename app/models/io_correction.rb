class IoCorrection < ApplicationRecord
  belongs_to :institution_order

  has_many :io_correction_products,
    -> { select( :id, :io_correction_id, :product_id, :date, :diff, :description, :code, :name ).joins( :product ) },
    dependent: :destroy

  #
  before_save :set_default_value

  def set_default_value
    institution_order = InstitutionOrder.find( institution_order_id)
    io_correction = IoCorrection.select( :number ).where( institution_order: institution_order ).last
    if io_correction
      number = institution_order.number[ 4..-1 ].to_i + 1
    else
      number = 1
    end

    self.number ||= "#{ institution_order.institution.prefix }-#{ number.to_s.rjust(8, '0' ) }"
    self.date ||= Date.today
  end

end
