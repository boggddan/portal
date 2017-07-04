class MenuRequirement < ApplicationRecord
  belongs_to :branch
  belongs_to :institution

  has_many :menu_meals_dishes, dependent: :destroy
  has_many :menu_children_categories, dependent: :destroy
  has_many :menu_products, dependent: :destroy

  #
  before_save :set_default_value

  def set_default_value
    self.number ||= number_next( self.class, institution_id )
    self.splendingdate ||= self.date ||= Date.today
  end

end
