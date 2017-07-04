$( document ).on 'turbolinks:load', ->

  $attendanceOfChildren = $( '#attendance_of_children' )
  if $attendanceOfChildren.length
    $parentElem = $attendanceOfChildren

    $sessionKey = $parentElem.attr 'id'
    $dateStartSession = MyLib.getSession( $sessionKey )?.date_start
    $dateEndSession = MyLib.getSession( $sessionKey )?.date_end
    $childrenGroupSession = MyLib.getSession( $sessionKey )?.children_group

    ########
    $parentElem
      .find( '.btn_create, .btn_print' )
        .click -> # Нажатие на кнопочку создать
          $dateStart = $( '#date_start' )
          $dateEnd = $( '#date_end' )
          $childrenGroupCode = $( '#children_group_code' )
          MyLib.ajax(
            "Формування табеля в 1С"
            $parentElem.data( 'path-view' )
            'post'
              date_start: $dateStart.val( )
              date_end: $dateEnd.val( )
              children_group: $childrenGroupCode.val( )
              is_pdf: $( @ ).hasClass( 'btn_print' )
            'json'
            false
            false
            true )
      .end( )
      .find( '#date_start' ) # Начальная дата фильтрации
        .val $dateStartSession
        .data 'old-value', $dateStartSession
        .attr readonly: true, placeholder: 'Дата...'
        .datepicker( onSelect: -> MyLib.selectDateStart $( @ ), '#date_end', false )
      .end( )
      .find( '#date_end' ) # Конечная дата фильтрации
        .val $dateEndSession
        .data 'old-value', $dateEndSession
        .attr readonly: true, placeholder: 'Дата...'
        .datepicker( onSelect: -> MyLib.selectDateEnd $( @ ), '#date_start', false )
      .end( )
      .find( '#children_group_code' ) # Конечная дата фильтрации
        .val $childrenGroupSession
        .change -> setSession( $sessionKey, { children_group: $( @ ).val( ) } )
      .end( )
