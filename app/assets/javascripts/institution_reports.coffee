$( document ).on 'turbolinks:load', ->

  if $( '#institution_reports' ).length
    $parentElem = $( '#institution_reports' )

    $( '#main_menu li' ).removeClass 'active'
    $( '#mm_institution_reports' ).addClass 'active'

    $( '#children_day_cost' ).click -> # Вартість дітодня за меню-вимогами
      window.location.replace $parentElem.data 'path-children-day-cost'

    $( '#balances_in_warehouses' ).click -> # Залишки продуктів харчування
      window.location.replace $parentElem.data 'path-balances-in-warehouses'

    $( '#attendance_of_children' ).click -> # Залишки продуктів харчування
      window.location.replace $parentElem.data 'path-attendance-of-children'