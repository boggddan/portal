class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all.order( :username )
  end

  def ajax_delete_user # Удаление
    User.delete_all( id: params[ :id ] ) if params[ :id ]
  end

end
