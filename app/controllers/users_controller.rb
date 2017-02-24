class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.order(:username)
  end

  def ajax_delete_user # Удаление
    User.delete_all(id: params[:id]) if params[:id].present?
  end

end
