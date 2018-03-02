class User < ApplicationRecord
  has_secure_password

  belongs_to :userable, polymorphic: true, optional: true
  belongs_to :supplier, foreign_key: :userable_id, optional: true
  belongs_to :institution, foreign_key: :userable_id, optional: true

  def is_admin?
    self.userable_type == 'Admin'
  end

  def is_institution?
    self.userable_type == 'Institution'
  end

  def type_short
    if self.userable_type == 'Admin' then 'А'
      elsif self.userable_type == 'Institution' && self.institution_type_code == 1 then 'Д'
      elsif self.userable_type == 'Institution' && self.institution_type_code == 2 then 'Ш'
      elsif self.userable_type == 'Supplier' then 'П'
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
