class User < ApplicationRecord
  #has_secure_password
  belongs_to :institution
  belongs_to :supplier


  validates :username, presence: true, uniqueness: true
end
