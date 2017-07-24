class Admin::UsersController < Admin::BaseController
  def index ; end

  def filter_users # Фильтрация документов
    @users = JSON.parse( User
      .left_outer_joins( :institution, :supplier )
      .select( :id, :username, :created_at, :updated_at, :userable_type,
               'suppliers.name AS supplier_name', 'institutions.name AS institution_name' )
      .to_json( except: [ :userable_type, :supplier_name, :institution_name ],
                methods: [ :type_short, :organization ] ),
      symbolize_names: true )

      #.order( "#{ params[ :sort_field ] } #{ params[ :sort_order ] }" )
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
    @institution = Institution.select( :name, :id  ).order( :name ).pluck( :name, :id )
    @supplier = Supplier.select( :id, :name ).order( :name ).pluck( :name, :id )
    @user = id ?
      User.select( :id, :username, :userable_id, :userable_type ).find( id ).to_json
      : JSON.generate( { id: '', username: '', userable_id: '', userable_type: 'Admin' } )
  end

  def create #
    par = params.permit( :username, :password, :userable_id, :userable_type )
    id = params[ :id ]
    user = id.present? ? User.find( id ).update( par ) : User.create( par )
    render json: { status: true }
  end

end
