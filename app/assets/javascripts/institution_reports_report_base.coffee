$( document ).on 'turbolinks:load', ->

  $reportBase = $( '#report_base' )
  if $reportBase.length
    $parentElem = $reportBase
    $sessionKey = $parentElem.attr 'id'
    $dateStartSession = MyLib.getSession( $sessionKey )?.date_start
    $dateEndSession = MyLib.getSession( $sessionKey )?.date_end

    ########
    $parentElem
      .find( '.btn_create, .btn_print' )
        .click -> # Нажатие на кнопочку создать
          $dateStart = $( '#date_start' )
          $dateEnd = $( '#date_end' )
          MyLib.ajax(
            "Формування звіта в 1С"
            $parentElem.data( 'path-view' )
            'post'
              date_start: $dateStart.val( )
              date_end: $dateEnd.val( )
              is_pdf: if $( '.btn_print').length then $( @ ).hasClass( 'btn_print' ) else null
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
