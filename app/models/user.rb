class User < ApplicationRecord
  has_secure_password

  belongs_to :userable, polymorphic: true, optional: true
  belongs_to :supplier, foreign_key: :userable_id, optional: true
  belongs_to :institution, foreign_key: :userable_id, optional: true

  validates :username, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :username, presence: true, confirmation: true
#  validates_confirmation_of :password
end
