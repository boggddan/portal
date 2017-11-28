class ProductsMoveProduct < ApplicationRecord
  belongs_to :products_move
  belongs_to :product
end
