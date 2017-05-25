class PriceProduct < ApplicationRecord
  belongs_to :branch
  belongs_to :institution
  belongs_to :product
end
