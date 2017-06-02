$( document ).on 'turbolinks:load', ->
  $timesheets = $( '#timesheets' )
  if $timesheets.length
    $parentElem = $timesheets

    $sessionKey = $parentElem.attr 'id'
    $dateStartSession = window.getSession( $sessionKey )?.date_start
    $dateEndSession = window.getSession( $sessionKey )?.date_end

    $( "#main_menu li[data-page=#{ $sessionKey }]" ).addClass( 'active' ).siblings(  ).removeClass 'active'

    getTable = ->
      $sessionObj = window.getSession( $sessionKey )
      $clmn = $( '#col_t' )
      $clmnObj = $sessionObj[ $clmn.attr 'id' ]
      window.ajax(
        'Фільтрація табелів'
        $clmn.data 'path-filter'
        'post'
          date_start: $sessionObj.date_start
          date_end: $sessionObj.date_end
          sort_field: $clmnObj?.sort_field
          sort_order: $clmnObj?.sort_order
        'script' ) if $sessionObj?.date_start

    filterTable = -> # Фильтрация таблицы документов
      setClearTableSession $sessionKey, 'main'
      getTable( )

    getTable( ) # Запрос таблицы документов

    ########
    $( '#col_t' )
      .find( '#date_start' ) # Начальная дата фильтрации
        .val $dateStartSession
        .data 'old-value', $dateStartSession
        .attr readonly: true, placeholder: 'Дата...'
        .datepicker( onSelect: -> window.selectDateStart $( @ ), '#date_end', filterTable )
      .end( )
      .find( '#date_end' ) # Конечная дата фильтрации
        .val $dateEndSession
        .data 'old-value', $dateEndSession
        .attr readonly: true, placeholder: 'Дата...'
        .datepicker( onSelect: -> window.selectDateEnd $( @ ), '#date_start', filterTable )
      .end( )
      .find( '.btn_create' )
        .click -> assignLocation( $('#col_t').data( 'path-new' ) )
      .end( )
      .on 'click', 'td, th[data-sort]', ->
        $this = $( @ )
        if $this.is 'th'
          window.tableHeaderClick $( @ ), filterTable # Нажатие для сортировки
        else
          $button = $this.children 'button'
          $tr = $this.closest 'tr'

          window.rowSelect $tr unless $tr.hasClass 'selected'

          window.tableButtonClick( $button, false ) if $button.length