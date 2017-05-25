$( document ).on 'turbolinks:load', ( ) ->

  if $( '#timesheet_new' ).length # Если объект существует
    $parentElem = $( '#timesheet_new' )

    $( '#main_menu li' ).removeClass 'active'
    $( '#mm_timesheets' ).addClass 'active'

    $( '#date, #date_eb, #date_ee' ).datepicker( ) # Дата

    $( '.btn_create' ).click ->  # Нажатие на кнопочку создать
      $( '#dialog_wait' ).dialog 'open'
      $dateEb = $( '#date_eb' )
      $dateEe = $( '#date_ee' )
      $date = $( '#date' )

      $path = "#{ $parentElem.data 'path-create'  }?#{ $dateEb.attr 'name' }=#{ $dateEb.val( ) }
        &#{ $dateEe.attr 'name' }=#{ $dateEe.val() }&#{ $date.attr 'name' }=#{ $date.val( ) }"
      $.ajax url: $path, type: 'POST', dataType: 'script'

    $( '.btn_exit' ).click ->  # Нажатие на кнопочку выход
      window.location.replace $parentElem.data 'path-exit'