class IopPackage < ApplicationRecord
  belongs_to :institution_order_product
  belongs_to :suppliers_packages
end
