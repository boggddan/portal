class SuppliersPackage < ApplicationRecord
  belongs_to :institution
  belongs_to :supplier
  belongs_to :product
  belongs_to :package
end
