class Admin::BaseController < ApplicationController
  before_action :verify_admin

  layout 'admin'

  def verify_admin
    redirect_to root_path unless current_user && current_user[ :is_admin? ]
  end

  def index
    render 'admin/index'
  end
end
