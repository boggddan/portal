class MenuRequirement < ApplicationRecord
  belongs_to :branch
  belongs_to :institution

  has_many :menu_children_categories, dependent: :destroy
  has_many :menu_products, dependent: :destroy

  #
  before_save :set_default_value

  def set_default_value
    self.number ||= number_next( self.class, institution_id )
    self.splendingdate ||= self.date ||= Date.today
  end

#  has_many :products_group, -> (object) { where(menu_requirement: object.id).joins(:product).select('menu_products.product_id', 'products.name', 'products.code').group('menu_requirement.product_id').order('products.name').
#    left_joins(:price_products).select('price_products.price')

end
