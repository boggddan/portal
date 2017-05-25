$( document ).on 'turbolinks:load', ( ) ->

  if $( '#timesheet_dates' ).length
    $parentElem = $( '#timesheet_dates' )

    # Фильтрация категории / группы
    filterGroupTimesheet = ->
      $groupTimesheet = $( '#group_timesheet' )
      $groupTimesheetVal = $groupTimesheet.val( )
      $paramName = $groupTimesheet.children( 'option:selected' ).data 'field'

      if $groupTimesheetVal then $groupTimesheet.removeClass 'placeholder'
      else $groupTimesheet.addClass 'placeholder'

      $path = "#{ $parentElem.data 'path-filter' }?id=#{ $parentElem.data 'id' }
        &field=#{ $paramName }&field_id=#{ $groupTimesheetVal }"

      $.ajax url: $path, type: 'get', dataType: 'script'

    # Шапка формы
    header_text = -> $( 'h1' ).text "Табель №  #{ $( '#number' ).val() } від #{ $( '#date' ).val() }"

    ###############

    $( '#main_menu li' ).removeClass 'active'
    $( '#mm_timesheets' ).addClass 'active'

    header_text( )

    filterGroupTimesheet( ) # Фильтрация категории / группы

    # Выбор со списка категории / группы
    $( '#group_timesheet' ).addClass( 'placeholder' ).change -> filterGroupTimesheet( )

    # Дата
    $( '#date' )
      .data 'old-value', $( '#date' ).val( )
      .datepicker
        onSelect: ->
          $this = $( @ )
          $thisVal = $this.val( )

          if $thisVal isnt $this.data 'old-value'
            header_text( )
            $path = "#{ $parentElem.data 'path-update'  }?id=#{ $parentElem.data 'id' }
              &#{ $this.attr 'id' }=#{ $thisVal }"
            $.ajax url: $path, type: 'POST', dataType: 'script'

    # Нажатие на кнопочку создать
    $( '.btn_send' ).click ->
      $( '#dialog_wait' ).dialog 'open'

      $path = "#{ $parentElem.data 'path-send' }?id=#{ $parentElem.data 'id' }"
      $.ajax url: $path, type: 'POST', dataType: 'script'

    # Нажатие на кнопочку выход
    $( '.btn_exit, .btn_save' ).click ->
      window.location.replace $parentElem.data 'path-exit'