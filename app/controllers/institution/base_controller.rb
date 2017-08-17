class Institution::BaseController < ApplicationController
  layout 'institution'

  before_action :verify_institution
  helper_method :current_institution

  def verify_institution
    redirect_to root_path unless current_user && current_user[ :is_institution? ]
  end

  def index
    render 'institution/index'
  end

  def current_institution # Текущее подразделение
    JSON.parse( Institution
      .select( :id, :code, :name, :branch_id )
      .find( current_user[ :userable_id ] )
      .to_json, symbolize_names: true )
  end

  def current_branch # Текущее подразделение
    JSON.parse( Branch
      .joins( :institutions )
      .select( :id, :code, :name )
      .find_by( 'institutions.id': current_user[ :userable_id ] )
      .to_json, symbolize_names: true )
  end
end
