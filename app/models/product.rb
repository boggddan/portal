class Product < ApplicationRecord
  belongs_to :products_type
  has_many   :supplier_order_products
  has_many   :receipt_products
  has_many   :menu_products
  has_many   :institution_order_products
  has_many   :io_correction_products
  has_many   :suppliers_packages
  has_many   :dishes_products_norms
  has_many   :institutions_dishes_products
  has_many   :menu_products_price
  has_many   :institution_move_products
end
