class User < ApplicationRecord

  belongs_to :userable, polymorphic: true, optional: true



  #has_secure_password
  #belongs_to :institution
  #belongs_to :supplier



  validates :username, presence: true, uniqueness: true
end
