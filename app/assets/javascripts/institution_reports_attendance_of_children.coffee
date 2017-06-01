$( document ).on 'turbolinks:load', ->

  $attendanceOfChildren = $( '#attendance_of_children' )
  if $attendanceOfChildren.length
    $parentElem = $attendanceOfChildren

    $sessionKey = $parentElem.attr 'id'
    $dateStartSession = window.getSession( $sessionKey )?.date_start
    $dateEndSession = window.getSession( $sessionKey )?.date_end

    $( "#main_menu li[data-page=institution_reports]" ).addClass( 'active' ).siblings(  ).removeClass 'active'

    ########
    $parentElem
      .find( '.btn_create' )
        .click -> # Нажатие на кнопочку создать
          $dateStart = $( '#date_start' )
          $dateEnd = $( '#date_end' )
          $childrenGroupCode = $( '#children_group_code' )
          window.ajax(
            "Формування табеля в 1С"
            $parentElem.data( 'path-view' )
            'post'
              date_start: $dateStart.val( )
              date_end: $dateEnd.val( )
              children_group: $childrenGroupCode.val( )
            'script'
            false
            false
            true )
      .end( )
      .find( '#date_start' ) # Начальная дата фильтрации
        .val $dateStartSession
        .data 'old-value', $dateStartSession
        .attr readonly: true, placeholder: 'Дата...'
        .datepicker( onSelect: -> window.selectDateStart $( @ ), '#date_end', false )
      .end( )
      .find( '#date_end' ) # Конечная дата фильтрации
        .val $dateEndSession
        .data 'old-value', $dateEndSession
        .attr readonly: true, placeholder: 'Дата...'
        .datepicker( onSelect: -> window.selectDateEnd $( @ ), '#date_start', false )
      .end( )

    ########




#    #  Начальная дата фильтрации
#    $( '#date_start' )
#      .val( moment( ).startOf('month').format( $formatDate ) )
#      .data( 'old-value', moment( ).startOf('month').format( $formatDate ) )
#      .datepicker onSelect: ->
#        $this = $( @ )
#        $thisVal =  $this.val( )
#
#        if $thisVal isnt $this.data 'old-value'
#          $this.data 'old-value', $thisVal
#          $dateEnd = $( '#date_end' )
#
#          if moment( $thisVal, $formatDate ).isAfter( moment( $dateEnd.val( ), $formatDate ) )
#            $dateEnd.val( $thisVal ).data 'old-value', $thisVal
#
#    #  Конечная дата фильтрации
#    $( '#date_end' )
#      .val( moment( ).endOf('month').format( $formatDate ) )
#      .data( 'old-value', moment( ).endOf('month').format( $formatDate ) )
#      .datepicker onSelect: ->
#        $this = $( @ )
#        $thisVal =  $this.val( )
#
#        if $thisVal isnt $this.data 'old-value'
#          $this.data 'old-value', $thisVal
#          $dateStart = $( '#date_start' )
#
#          if moment( $thisVal, $formatDate ).isBefore( moment( $dateStart.val( ), $formatDate ) )
#            $dateStart.val( $thisVal ).data 'old-value', $thisVal
#
#    # Нажатие на кнопочку создать
#    $( '.btn_create' ).click ->
#      $( '#dialog_wait' ).dialog 'open'
#      $dateStart = $( '#date_start' )
#      $dateEnd = $( '#date_end' )
#      $childrenGroupCode = $( '#children_group_code' )
#
#      $path = "#{ $parentElem.data( 'path-view' ) }?#{ $dateStart.attr 'id'  }=#{ $dateStart.val( ) }\
#        &#{ $dateEnd.attr 'id' }=#{ $dateEnd.val( ) }&#{ $childrenGroupCode.attr 'id' }=#{ $childrenGroupCode.val( ) }"
#      $.ajax url: $path, type: 'post', dataType: 'script'
#
#    # Нажатие на кнопочку выход
#    $( '.btn_exit' ).click ->
#      window.location.replace $parentElem.data 'path-exit'
