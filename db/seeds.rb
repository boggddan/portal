
# Первичная настройка пользователя
User.create( username: 'admin', userable_id: 0, userable_type: 'admin' )
User.create( username: '123', userable: Institution.find_by( code: '14' ) )

# Создание для табеля Явки
ReasonsAbsence.create( code: '', mark: '', name: 'Явка'  )