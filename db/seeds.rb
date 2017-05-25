
# Первичная настройка пользователя
User.delete_all
User.create( username: 'admin', password: 'admin', userable_id: 0, userable_type: 'Admin' )
User.create( username: 'user', password: '1', userable: Institution.find_by( code: '14' ) )

# Создание для табеля Явки
ReasonsAbsence.create_with( mark: '', name: 'Явка', priority: 0 ).find_or_create_by( code: '' )

# Пустая причина
CausesDeviation.create_with( name: '' ).find_or_create_by( code: '' )

# Пустой тип товара
ProductsType.create_with( name: '', priority: 0 ).find_or_create_by( code: '' )