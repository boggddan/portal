$( document ).on 'turbolinks:load', ->
  # Если объект существует
  $institutionOrders = $( '#institution_orders' )
  if $institutionOrders.length

    $parentElem = $institutionOrders

    $sessionKey = $parentElem.attr 'id'

    $dateStartSession = MyLib.getSession( $sessionKey )?.dateStart || MyLib.toDateFormat( moment( ).startOf( 'month' ) )
    MyLib.setSession( $sessionKey, { dateStart: $dateStartSession } );

    $dateEndSession = MyLib.getSession( $sessionKey )?.dateEnd || MyLib.toDateFormat( moment( ).endOf( 'month' ) )
    MyLib.setSession( $sessionKey, { dateEnd: $dateEndSession } );

    $( "#main_menu li[data-page=#{ $sessionKey }]" ).addClass( 'active' ).siblings(  ).removeClass 'active'

    getTable = ->
      $sessionObj = MyLib.getSession( $sessionKey )
      $clmn = $( '#col_io' )
      $clmnObj = $sessionObj[ $clmn.attr 'id' ]
      MyLib.ajax(
        'Фільтрація заявки'
        $clmn.data 'path-filter'
        'post'
          date_start: $sessionObj.dateStart
          date_end: $sessionObj.dateEnd
          sort_field: $clmnObj?.sortField || ''
          sort_order: $clmnObj?.sortOrder || ''
        'script'
        false
        true  ) if $sessionObj?.dateStart

    getTableCorrection = ->
      $sessionObj = MyLib.getSession( $sessionKey )
      $clmn = $( '#col_ioc' )
      $clmnObj = $sessionObj[ $clmn.attr 'id' ]

      $clmnIoObj = $sessionObj[ 'col_io' ]
      $institutionOrderId = $clmnIoObj?.row_id
      if $institutionOrderId
        MyLib.ajax(
          'Фільтрація коригування заявки'
          $clmn.data 'path-filter'
          'post'
            institution_order_id: $institutionOrderId
            sort_field: $clmnObj?.sortField || ''
            sort_order: $clmnObj?.sortOrder || ''
          'script'
          null
          true  )
      else
        $clmn
          .find( '.parent_table' ).empty( )
          .end( )
          .find( 'h1' ).text( $clmn.data 'captions' )
          .end( )
          .find( '.btn_create' ).prop 'disabled', true

    filterTable = -> # Фильтрация таблицы документов
      MyLib.setClearTableSession( $sessionKey, 'col_io' )
      getTable( )
      filterTableCorrection( )

    filterTableCorrection = -> # Фильтрация таблицы документов
      MyLib.setClearTableSession( $sessionKey, 'col_ioc' )
      getTableCorrection( )

    getTable( ) # Запрос таблицы документов
    getTableCorrection( )

    ########
    $( '#col_io' )
      .find( '.btn_create' )
        .click -> # Нажатие на кнопочку создать
          MyLib.createDoc(
            $( @ )
            date_start: $( '#date_start' ).val( ), date_end: $( '#date_end' ).val( ) )
      .end( )
      .find( '#date_start' ) # Начальная дата фильтрации
        .val $dateStartSession
        .data 'old-value', $dateStartSession
        .attr readonly: true, placeholder: 'Дата...'
        .datepicker( onSelect: -> MyLib.selectDateStart $( @ ), '#date_end', filterTable )
      .end( )
      .find( '#date_end' ) # Конечная дата фильтрации
        .val $dateEndSession
        .data 'old-value', $dateEndSession
        .attr readonly: true, placeholder: 'Дата...'
        .datepicker( onSelect: -> MyLib.selectDateEnd $( @ ), '#date_start', filterTable )
      .end( )
      .on 'click', 'td, th[data-sort]', ->
        $this = $( @ )
        if $this.is 'th'
          MyLib.tableHeaderClick( $( @ )[ 0 ], filterTable ) # Нажатие для сортировки
        else
          $button = $this.children 'button'
          $tr = $this.closest 'tr'

          MyLib.rowClick( $tr[ 0 ], filterTableCorrection ) unless $tr.hasClass 'selected'

          if $button.hasClass('btn_del')
            buttonDel = ( ) ->
              $( '#col_io .btn_create' ).prop 'disabled', if $( '#col_io table' ).length then true else false
              filterTableCorrection( )

            MyLib.tableDelClick( $button[ 0 ], buttonDel )
          else if $button.hasClass('btn_view') or $button.hasClass('btn_edit')
            MyLib.tableEditClick( $button[ 0 ] )

    ########
    $( '#col_ioc' )
      .find( '.btn_create' )
        .click -> # Нажатие на кнопочку создать
          $this = $( @ )
          MyLib.createDoc(
            $this
            institution_order_id: $this.closest( '.clmn' ).data 'institution-order-id' )
      .end( )
      .on 'click', 'td, th[data-sort]', ->
        $this = $( @ )
        if $this.is 'th'
          MyLib.tableHeaderClick( $( @ )[ 0 ], filterTableCorrection ) # Нажатие для сортировки
        else
          $button = $this.children 'button'
          $tr = $this.closest 'tr'

          MyLib.rowClick( $tr[ 0 ], null ) unless $tr.hasClass 'selected'

          if $button.hasClass('btn_del')
            buttonDel = ( ) -> $( '#col_ioc .btn_create' ).prop 'disabled', false

            MyLib.tableDelClick( $button[ 0 ], buttonDel )
          else if $button.hasClass('btn_view') or $button.hasClass('btn_edit')
            MyLib.tableEditClick( $button[ 0 ] )
