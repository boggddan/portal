class Institution::BaseController < ApplicationController
  before_action :verify_institution

  layout 'institution'

  def current_institution # Текущее подразделение
    current_user.institution
  end

  def current_branch # Текущий отдел
    current_institution.branch
  end
end