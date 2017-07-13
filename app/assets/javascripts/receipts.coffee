$( document ).on 'turbolinks:load', ->
  # Если объект существует
  $receipts = $( '#receipts' )
  if $receipts.length

    $parentElem = $receipts

    $sessionKey = $parentElem.attr 'id'
    $dateStartSession = MyLib.getSession( $sessionKey )?.date_start || MyLib.toDateFormat( moment( ).startOf( 'month' ) )
    MyLib.setSession( $sessionKey, { date_start: $dateStartSession } );

    $dateEndSession = MyLib.getSession( $sessionKey )?.date_end || MyLib.toDateFormat( moment( ).endOf( 'month' ) )
    MyLib.setSession( $sessionKey, { date_end: $dateEndSession } );

    $( "#main_menu li[data-page=#{ $sessionKey }]" ).addClass( 'active' ).siblings(  ).removeClass 'active'

    getTable = ->
      $sessionObj = MyLib.getSession( $sessionKey )
      $clmn = $( '#col_so' )
      $clmnObj = $sessionObj[ $clmn.attr 'id' ]
      MyLib.ajax(
        'Фільтрація замовлення постачальникам'
        $clmn.data 'path-filter'
        'post'
          date_start: $sessionObj.date_start
          date_end: $sessionObj.date_end
          sort_field: $clmnObj?.sort_field
          sort_order: $clmnObj?.sort_order
        'script' ) if $sessionObj?.date_start

    getContractNumbers = ->
      $sessionObj = MyLib.getSession( $sessionKey )
      $clmn = $( '#col_r' )
      $clmnObj = $sessionObj[ $clmn.attr 'id' ]

      $clmnSoObj = $sessionObj[ 'col_so' ]
      $supplierOrderId = $clmnSoObj?.row_id

      if $supplierOrderId
        MyLib.ajax(
          'Фільтрація списку договорів постачання'
          $clmn.data 'path-filter-contracts'
          'post'
          supplier_order_id: $supplierOrderId
          'script' )
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
      $supplierOrderId = $clmnSoObj?.row_id

      if $supplierOrderId
        MyLib.ajax(
          'Фільтрація постачань'
          $clmn.data 'path-filter'
          'post'
            supplier_order_id: $supplierOrderId
            contract_number: $sessionObj?.contract_number
            sort_field: $clmnObj?.sort_field
            sort_order: $clmnObj?.sort_order
          'script' )
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
          MyLib.tableHeaderClick $( @ ), filterTable # Нажатие для сортировки
        else
          $tr = $this.closest 'tr'

          MyLib.rowSelect( $tr, filterContracts ) unless $tr.hasClass 'selected'

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
              supplier_order_id: $this.closest( '.clmn' ).data( 'supplier_order_id' )
              contract_number: $( '#contract_number' ).val( ) )
      .end( )
      .on 'click', 'td, th[data-sort]', ->
        $this = $( @ )
        if $this.is 'th'
          MyLib.tableHeaderClick $( @ ), filterTableReceipt # Нажатие для сортировки
        else
          $button = $this.children 'button'
          $tr = $this.closest 'tr'

          MyLib.rowSelect $tr unless $tr.hasClass 'selected'

          MyLib.tableButtonClick( $button, false ) if $button.length
