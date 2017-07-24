class User < ApplicationRecord
  has_secure_password

  belongs_to :userable, polymorphic: true, optional: true

  belongs_to :supplier, foreign_key: :userable_id, optional: true
  belongs_to :institution, foreign_key: :userable_id, optional: true

  # validates :username, presence: true, uniqueness: true, length: { maximum: 50 }
  # validates :username, presence: true, confirmation: true

  def is_admin?
    self.userable_type == 'Admin'
  end

  def is_institution?
    self.userable_type == 'Institution'
  end

  def type_short
    case self.userable_type
      when 'Admin' then 'А'
      when 'Institution' then 'Д'
      when 'Supplier' then 'П'
      esle ''
    end
  end

  def organization
    case self.userable_type
      when 'Admin' then 'Адміністратор'
      when 'Institution' then institution_name
      when 'Supplier' then supplier.name
      esle ''
    end
  end


end
