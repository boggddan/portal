class Admin::UsersController < Admin::BaseController
   def index
    @users = User.all.order( :username )
  end

  def delete # Удаление
    User.find_by( id: params[ :id ] ).destroy if params[ :id ]
  end

  def new #
    @institution = Institution.all.order( :name )
    @supplier = Supplier.all.order( :name )

    @user = params[ :id ] ? User.find_by( id: params[:id] ) : User.new( userable_type: 'Admin', userable_id: 0 )
  end


  def create #
    par = params.require( :user ).permit( :id, :username, :password, :password_confirmation, :userable_id, :userable_type )
    id = params[ :user ][ :id ]

    if id.blank? ? User.create( par ) : User.find_by( id: id ).update( par )
      redirect_to admin_users_index_path
    end
  end

end
