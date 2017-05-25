class Admin::BaseController < ApplicationController
  before_action :verify_admin

  layout 'admin'
end