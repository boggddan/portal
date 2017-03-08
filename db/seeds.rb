
# Первичная настройка пользователя
User.delete_all
User.create( username: 'admin', password: 'admin', userable_id: 0, userable_type: 'Admin' )
User.create( username: 'user', password: '1', userable: Institution.find_by( code: '14' ) )

# Создание для табеля Явки
ReasonsAbsence.create_with( mark: '', name: 'Явка' ).find_or_create_by!( code: '' )