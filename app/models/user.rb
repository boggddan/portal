class User < ApplicationRecord

  belongs_to :userable, polymorphic: true, optional: true

  #belongs_to :institution,  -> { where(userable_type: 'institution') }, foreign_key: :userable_id
  #belongs_to :supplier, foreign_key: :userable_id

  #has_secure_password
  #belongs_to :institution
  #belongs_to :supplier



  validates :username, presence: true, uniqueness: true
end
