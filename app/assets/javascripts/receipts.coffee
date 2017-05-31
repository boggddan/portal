$( document ).on 'turbolinks:load', ->
  # Если объект существует
  $receipts = $( '#receipts' )
  if $receipts.length

    $parentElem = $receipts

    $sessionKey = $parentElem.attr 'id'
    $dateStartSession = window.getSession( $sessionKey )?.date_start
    $dateEndSession = window.getSession( $sessionKey )?.date_end

    $( "#main_menu li[data-page=#{ $sessionKey }]" ).addClass( 'active' ).siblings(  ).removeClass 'active'

    getTable = ->
      $sessionObj = window.getSession( $sessionKey )
      $clmn = $( '#col_so' )
      $clmnObj = $sessionObj[ $clmn.attr 'id' ]
      window.ajax(
        'Фільтрація замовлення постачальникам'
        $clmn.data 'path-filter'
        'post'
          date_start: $sessionObj.date_start
          date_end: $sessionObj.date_end
          sort_field: $clmnObj?.sort_field
          sort_order: $clmnObj?.sort_order
        'script' ) if $sessionObj?.date_start

    getContractNumbers = ->
      $sessionObj = window.getSession( $sessionKey )
      $clmn = $( '#col_r' )
      $clmnObj = $sessionObj[ $clmn.attr 'id' ]

      $clmnSoObj = $sessionObj[ 'col_so' ]
      $supplierOrderId = $clmnSoObj?.row_id

      if $supplierOrderId
        window.ajax(
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
      $sessionObj = window.getSession( $sessionKey )
      $clmn = $( '#col_r' )
      $clmnObj = $sessionObj[ $clmn.attr 'id' ]

      $clmnSoObj = $sessionObj[ 'col_so' ]
      $supplierOrderId = $clmnSoObj?.row_id

      if $supplierOrderId
        window.ajax(
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
      setClearTableSession $sessionKey, 'col_so'
      getTable( )
      filterContracts( )

    filterContracts = -> # Фильтрация таблицы документов
      setDeleteElemSession( $sessionKey, 'contract_number' )
      getContractNumbers( )
      filterTableReceipt( )

    filterTableReceipt = -> # Фильтрация таблицы документов
      setClearTableSession $sessionKey, 'col_r'
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
        .datepicker( onSelect: -> window.selectDateStart $( @ ), '#date_end', filterTable )
      .end( )
      .find( '#date_end' ) # Конечная дата фильтрации
        .val $dateEndSession
        .data 'old-value', $dateEndSession
        .attr readonly: true, placeholder: 'Дата...'
        .datepicker( onSelect: -> window.selectDateEnd $( @ ), '#date_start', filterTable )
      .end( )
      .on 'click', 'td, th[data-sort]', ->
        $this = $( @ )
        if $this.is 'th'
          window.tableHeaderClick $( @ ), filterTable # Нажатие для сортировки
        else
          $tr = $this.closest 'tr'

          window.rowSelect( $tr, filterContracts ) unless $tr.hasClass 'selected'

    ########
    $( '#col_r' )
      .find( '#contract_number' )
        .change ->
          window.setSession( $sessionKey, { contract_number: $( @ ).val() } )
          receiptsSelectCountact( )
          getTableReceipts( )
      .end( )
      .find( '.btn_create' )
        .click -> # Нажатие на кнопочку создать
          $this = $( @ )
          window.createDoc(
            $this,
              supplier_order_id: $this.closest( '.clmn' ).data( 'supplier_order_id' )
              contract_number: $( '#contract_number' ).val( ) )
      .end( )
      .on 'click', 'td, th[data-sort]', ->
        $this = $( @ )
        if $this.is 'th'
          window.tableHeaderClick $( @ ), filterTableReceipt # Нажатие для сортировки
        else
          $button = $this.children 'button'
          $tr = $this.closest 'tr'

          window.rowSelect $tr unless $tr.hasClass 'selected'

          window.tableButtonClick( $button, false ) if $button.length