$( document ).on 'turbolinks:load', ->
  # Если объект существует
  $receipts = $( '#receipts' )
  if $receipts.length

    $parentElem = $receipts

    $sessionKey = $parentElem.attr 'id'
    $dateStartSession = MyLib.getSession( $sessionKey )?.dateStart || MyLib.toDateFormat( moment( ).startOf( 'month' ) )
    MyLib.setSession( $sessionKey, { dateStart: $dateStartSession } );

    $dateEndSession = MyLib.getSession( $sessionKey )?.dateEnd || MyLib.toDateFormat( moment( ).endOf( 'month' ) )
    MyLib.setSession( $sessionKey, { dateEnd: $dateEndSession } );

    $( "#main_menu li[data-page=#{ $sessionKey }]" ).addClass( 'active' ).siblings(  ).removeClass 'active'

    getTable = ->
      $sessionObj = MyLib.getSession( $sessionKey )
      $clmn = $( '#col_so' )
      $clmnObj = $sessionObj[ $clmn.attr 'id' ]
      MyLib.ajax(
        'Фільтрація замовлення постачальникам'
        $clmn.data 'path-filter'
        'post'
          date_start: $sessionObj.dateStart
          date_end: $sessionObj.dateEnd
          sort_field: $clmnObj?.sortField || ''
          sort_order: $clmnObj?.sortOrder || ''
        'script'
        null
        true  ) if $sessionObj?.dateStart

    getContractNumbers = ->
      $sessionObj = MyLib.getSession( $sessionKey )
      $clmn = $( '#col_r' )
      $clmnObj = $sessionObj[ $clmn.attr 'id' ]

      $clmnSoObj = $sessionObj[ 'col_so' ]
      $supplierOrderId = $clmnSoObj?.rowId

      $clmn[ 0 ].querySelector( '#contract_number' ).innerHTML = '<option value="">Договір</option>'

      if $supplierOrderId
        MyLib.ajax(
          'Фільтрація списку договорів постачання'
          $clmn.data 'path-filter-contracts'
          'post'
          supplier_order_id: $supplierOrderId
          'script'
          null
          true )
      else
        $clmn
          .find( 'h1' ).text( $clmn.data 'captions' )
          .end( )
          .find( 'select' ).prop( 'disabled', true )
          .end( )
          .find( '.btn_create' ).prop( 'disabled', true )

    getTableReceipts = ->
      $sessionObj = MyLib.getSession( $sessionKey )
      $clmn = $( '#col_r' )
      $clmnObj = $sessionObj[ $clmn.attr 'id' ]

      $clmnSoObj = $sessionObj[ 'col_so' ]
      $supplierOrderId = $clmnSoObj?.rowId

      if $supplierOrderId
        MyLib.ajax(
          'Фільтрація постачань'
          $clmn.data 'path-filter'
          'post'
            supplier_order_id: $supplierOrderId
            contract_number: $sessionObj?.contract_number || ''
            sort_field: $clmnObj?.sortField || ''
            sort_order: $clmnObj?.sortOrder || ''
          'script'
          null
          true )
      else
        $clmn.find( '.parent_table' ).empty( )

    filterTable = -> # Фильтрация таблицы документов
      MyLib.setClearTableSession $sessionKey, 'col_so'
      getTable( )
      filterContracts( )

    filterContracts = -> # Фильтрация таблицы документов
      MyLib.setDeleteElemSession( $sessionKey, 'contract_number' )
      getContractNumbers( )
      filterTableReceipt( )

    filterTableReceipt = -> # Фильтрация таблицы документов
      MyLib.setClearTableSession $sessionKey, 'col_r'
      getTableReceipts( )

    window.receiptsSelectCountact = ->
      $this = $( '#contract_number' )
      $thisVal = $this.val( )

      if $thisVal
        $this.removeClass( 'placeholder' )
        $disabled = false
      else
        $this.addClass( 'placeholder' )
        $disabled = true

      $this.siblings( '.btn_create' ).prop 'disabled', $disabled

    getTable( ) # Запрос таблицы документов
    getContractNumbers( )
    getTableReceipts( )

    ########
    $( '#col_so' )
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
          $tr = $this.closest 'tr'

          MyLib.rowClick( $tr[ 0 ], filterContracts ) unless $tr.hasClass 'selected'

    ########
    $( '#col_r' )
      .find( '#contract_number' )
        .change ->
          MyLib.setSession( $sessionKey, { contract_number: $( @ ).val() } )
          receiptsSelectCountact( )
          getTableReceipts( )
      .end( )
      .find( '.btn_create' )
        .click -> # Нажатие на кнопочку создать
          $this = $( @ )
          MyLib.createDoc(
            $this,
              supplier_order_id: $this.closest( '.clmn' ).data( 'supplier-order-id' )
              contract_number: $( '#contract_number' ).val( ) )
      .end( )
      .on 'click', 'td, th[data-sort]', ->
        $this = $( @ )
        if $this.is 'th'
          MyLib.tableHeaderClick( $( @ )[ 0 ], filterTableReceipt ) # Нажатие для сортировки
        else
          $button = $this.children 'button'
          $tr = $this.closest 'tr'

          MyLib.rowClick( $tr[ 0 ], null ) unless $tr.hasClass 'selected'

          if $button.hasClass('btn_del')
            MyLib.tableDelClick( $button[ 0 ], null )
          else if $button.hasClass('btn_view') or $button.hasClass('btn_edit')
            MyLib.tableEditClick( $button[ 0 ] )
