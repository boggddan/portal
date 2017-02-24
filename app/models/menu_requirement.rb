class MenuRequirement < ApplicationRecord
  belongs_to :branch
  belongs_to :institution

  has_many :menu_children_categories
  has_many :menu_products

  #
  before_save :set_default_value

  def set_default_value
    menu_requirement = MenuRequirement.select(:number).where( institution_id: institution_id ).last
    if menu_requirement
      number = menu_requirement.number.to_i + 1
    else
      number = 1
    end

    self.number ||= number.to_s.rjust(12, '0')
    self.splendingdate ||= self.date ||= Date.today
  end

#  has_many :products_group, -> (object) { where(menu_requirement: object.id).joins(:product).select('menu_products.product_id', 'products.name', 'products.code').group('menu_requirement.product_id').order('products.name').
#    left_joins(:price_products).select('price_products.price')

end
