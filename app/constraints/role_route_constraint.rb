class RoleRouteConstraint
  def initialize( attr = false )
    @attr = attr
  end

  def matches?( request )
    user = current_user( request.session[ :user_id ] ) if @attr
    user.present? && Proc.new { | user | user.try( @attr ) || false }.call( user )
  end

  def current_user( user_id )
    User.find_by( id: user_id ) if user_id
  end
end
