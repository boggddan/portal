class Package < ApplicationRecord

  has_many :suppliers_packages
  has_many :iop_packages
end
