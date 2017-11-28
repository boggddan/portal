class ProductsMove < ApplicationRecord
  belongs_to :institution
  belongs_to :to_institution, class_name: 'Institution'
  has_many   :products_move_products
end
