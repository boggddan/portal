class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @users = User.all.order( :username )
  end

  def delete # Удаление
    User.find_by( id: params[ :id ] ).destroy if params[ :id ]
  end

end
