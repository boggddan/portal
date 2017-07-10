class Institution::BaseController < ApplicationController
  before_action :verify_institution

  layout 'institution'

  def verify_institution
    redirect_to root_path unless current_user.is_institution?
  end

  def index
    render 'institution/index.slim'
  end

  def current_institution # Текущее подразделение
    current_user.institution
  end

  def current_branch # Текущий отдел
    current_institution.branch
  end
end
