$( document ).on 'turbolinks:load', ->
  $timesheetNew = $( '#timesheet_new' )
  if $timesheetNew.length
    $parentElem = $timesheetNew

    $sessionKey = $parentElem.attr 'id'
    $dateStartSession = window.getSession( $sessionKey )?.date_start
    $dateEndSession = window.getSession( $sessionKey )?.date_end

    $( "#main_menu li[data-page=timesheets]" ).addClass( 'active' ).siblings(  ).removeClass 'active'

    ########
    $( '#col_t' )
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
      .find( '.btn_create' )
        .click ->
          window.createDoc(
            $( @ )
            date_start: $( '#date_start' ).val( ), date_end: $( '#date_end' ).val( ) )
      .end( )
      .find( '.btn_exit' )
        .click -> assignLocation( $('#col_t').data( 'path-exit' ) )
      .end( )