meal = Meal.find_by( code: '' )
dish = Dish.find_by( code: '' )

MenuRequirement.all.each do | mr |
  unless mr.menu_meals_dishes.present?
    md = mr.menu_meals_dishes.create( menu_requirement: mr, meal: meal, dish: dish, is_enabled: true )
    mr.menu_products.update( menu_meals_dish: md )
  end
end


