class Admin::UsersController < Admin::BaseController
  def index ; end

  def filter_users # Фильтрация документов
    @users = JSON.parse( User
      .left_outer_joins( :institution, :supplier )
      .select( :id,
               :username,
               :created_at,
               :updated_at,
               :userable_type,
               'suppliers.name AS supplier_name',
               'institutions.institution_type_code',
               'institutions.name AS institution_name' )
      .to_json( except: [ :userable_type, :supplier_name, :institution_name ],
                methods: [ :type_short, :organization ] ),
      symbolize_names: true )

      sort_field = params[ :sort_field ]

      if sort_field
        @users = @users.sort_by { | v | v [ sort_field.to_sym ] }
        @users = @users.reverse if params[ :sort_order ] == 'desc'
      end
  end

  def delete # Удаление
    User.find( params[ :id ] ).destroy
    render json: { status: true }
  end

  def new #
    id = params[ :id ]
    @kindergartens = Institution.select_name.kindergarten.order_name.pluck( :name, :id )
    @schools = Institution.select_name.school.order_name.pluck( :name, :id )

    @supplier = Supplier.select( :id, :name ).order( :name ).pluck( :name, :id )

    @user = ( id \
      ? User
        .joins( :institution )
        .select( :id, :username, :userable_id, :userable_type, 'institutions.institution_type_code as type' )
        .find( id )
      : { id: '', username: '', userable_id: '', userable_type: 'Admin' }
    ).to_json
  end

  def create #
    par = params.permit( :username, :password, :userable_id, :userable_type )
    id = params[ :id ]
    user = id.present? ? User.find( id ).update( par ) : User.create( par )
    render json: { status: true }
  end

end
