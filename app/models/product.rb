class Product < ApplicationRecord
  belongs_to :products_type
  has_many   :supplier_order_products
  has_many   :receipt_products
  has_many   :menu_products
  has_many   :institution_order_products
  has_many   :io_correction_products
  has_many   :price_products
  has_many   :suppliers_packages
end
