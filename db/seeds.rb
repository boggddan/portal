# Первичная настройка пользователя

Branch.create( code: '', name: 'Загальний' ) unless Branch.find_by( code: '' )
Institution.create( code: 0, name: 'Загальний', branch: Branch.find_by( code: '' ) ) unless Institution.find_by( code: 0 )

Branch.create( code: '00000000006', name: 'ТВО Вознесенівського району' ) unless Branch.find_by( code: '00000000006' )
Institution.create( code: 14, name: '18 (ДОУ)', branch: Branch.find_by( code: '00000000006' ) ) unless Institution.find_by( code: 14 )

# Создание для табеля Явки
ReasonsAbsence.create_with( mark: '', name: 'Явка', priority: 0 ).find_or_create_by( code: '' )

# Пустая причина
CausesDeviation.create_with( name: '' ).find_or_create_by( code: '' )

# Пустой тип товара
ProductsType.create_with( name: '', priority: 0 ).find_or_create_by( code: '' )

# Пустая категория блюд
DishesCategory.create_with( name: '', priority: 9999 ).find_or_create_by( code: '' )

# Пустой тип блюда
Dish.create_with( name: 'ЗАГАЛЬНЕ', priority: -1, dishes_category: DishesCategory.find_by( code: '' ) ).find_or_create_by( code: '' )

# Пустой тип приема пищи
Meal.create_with( name: 'ЗАГАЛЬНЕ', priority: 9999 ).find_or_create_by( code: '' )

User.create( username: 'admin', password: 'admin', userable_id: 0, userable_type: 'Admin' ) unless User.find_by( username: 'admin' )
User.create( username: 'user', password: '1', userable: Institution.find_by( code: '14' ) ) unless User.find_by( username: 'user' )
