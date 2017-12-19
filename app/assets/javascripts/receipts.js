/* eslint space-before-function-paren: off, no-invalid-this: off, func-names: off */

$( document ).on( 'turbolinks:load', ( ) => {
  const $receipts = $( '#receipts' );
  if ( $receipts.length ) {
    const $parentElem = $receipts;

    const sessionKey = $parentElem.attr( 'id' );

    const dateStartSession = ( MyLib.getSession( sessionKey ) ||
      { } ).dateStart || MyLib.toDateFormat( moment( ).startOf( 'month' ) );

    MyLib.setSession( sessionKey, { dateStart: dateStartSession } );

    const dateEndSession = ( MyLib.getSession( sessionKey ) ||
      { } ).dateEnd || MyLib.toDateFormat( moment( ).endOf( 'month' ) );

    MyLib.setSession( sessionKey, { dateEnd: dateEndSession } );

    MyLib.mainMenuActive( sessionKey );

    const getTable = ( ) => {
      const $sessionObj = MyLib.getSession( sessionKey );
      const $clmn = $( '#col_so' );
      const { [ $clmn.attr( 'id' ) ]: $clmnObj } = $sessionObj;

      if ( ( $sessionObj || { } ).dateStart ) {
        MyLib.ajax(
          'Фільтрація замовлення постачальникам',
          $clmn.data( 'path-filter' ),
          'post',
          {
            date_start: $sessionObj.dateStart,
            date_end: $sessionObj.dateEnd,
            sort_field: ( $clmnObj || { } ).sortField || '',
            sort_order: ( $clmnObj || { } ).sortOrder || ''
          },
          'script',
          null,
          true );
      }
    };

    const getContractNumbers = ( ) => {
      const $sessionObj = MyLib.getSession( sessionKey );
      const $clmn = $( '#col_r' );
      const { col_so: $clmnSoObj } = $sessionObj;
      const { rowId: $supplierOrderId } = $clmnSoObj || { };

      $clmn[ 0 ].querySelector( '#contract_number' ).innerHTML = '<option value="">Договір</option>';

      if ( $supplierOrderId ) {
        MyLib.ajax(
          'Фільтрація списку договорів постачання',
          $clmn.data( 'path-filter-contracts' ),
          'post',
          { supplier_order_id: $supplierOrderId },
          'script',
          null,
          true );
      } else {
        $clmn
          .find( 'h1' ).text( $clmn.data( 'captions' ) )
          .end( )
          .find( 'select' ).prop( 'disabled', true )
          .end( )
          .find( '.btn_create' )
          .prop( 'disabled', true );
      }
    };

    const getTableReceipts = ( ) => {
      const $sessionObj = MyLib.getSession( sessionKey );
      const $clmn = $( '#col_r' );
      const { [ $clmn.attr( 'id' ) ]: $clmnObj } = $sessionObj;

      const { col_so: $clmnSoObj } = $sessionObj;
      const { rowId: $supplierOrderId } = $clmnSoObj || { };

      if ( $supplierOrderId ) {
        MyLib.ajax(
          'Фільтрація постачань',
          $clmn.data( 'path-filter' ),
          'post',
          {
            supplier_order_id: $supplierOrderId,
            contract_number: ( $sessionObj || { } ).contract_number || '',
            sort_field: ( $clmnObj || { } ).sortField || '',
            sort_order: ( $clmnObj || { } ).sortOrder || ''
          },
          'script',
          null,
          true );
      } else {
        $clmn.find( '.parent_table' ).empty( );
      }
    };

    const filterTableReceipt = ( ) => { // фильтрация таблицы документов
      MyLib.setClearTableSession( sessionKey, 'col_r' );
      getTableReceipts( );
    };

    const filterContracts = ( ) => { // фильтрация таблицы документов
      MyLib.setDeleteElemSession( sessionKey, 'contract_number' );
      getContractNumbers( );
      filterTableReceipt( );
    };

    const filterTable = ( ) => { // фильтрация таблицы документов
      MyLib.setClearTableSession( sessionKey, 'col_so' );
      getTable( );
      filterContracts( );
    };

    window.receiptsSelectCountact = ( ) => {
      const $this = $( '#contract_number' );
      const $thisVal = $this.val( );

      let $disabled = false;

      if ( $thisVal ) {
        $this.removeClass( 'placeholder' );
      } else {
        $this.addClass( 'placeholder' );
        $disabled = true;
      }

      $this.siblings( '.btn_create' ).prop( 'disabled', $disabled );
    };

    getTable( ); // запрос таблицы документов
    getContractNumbers( );
    getTableReceipts( );

    //-----------------------
    $( '#col_so' )
      .find( '#date_start' ) // начальная дата фильтрации
      .val( dateStartSession )
      .data( 'old-value', dateStartSession )
      .attr( { readonly: true, placeholder: 'Дата...' } )
      .datepicker( { onSelect( ) { MyLib.selectDateStart( $( this ), '#date_end', filterTable ) } } )
      .end( )
      .find( '#date_end' ) // конечная дата фильтрации
      .val( dateEndSession )
      .data( 'old-value', dateEndSession )
      .attr( { readonly: true, placeholder: 'Дата...' } )
      .datepicker( { onSelect( ) { MyLib.selectDateEnd( $( this ), '#date_start', filterTable ) } } )
      .end( )
      .on( 'click', 'td, th[data-sort]', function( ) {
        const $this = $( this );
        if ( $this.is( 'th' ) ) {
          MyLib.tableHeaderClick( $this[ 0 ], filterTable ); // нажатие для сортировки
        } else {
          const $tr = $this.closest( 'tr' );
          if ( !$tr.hasClass( 'selected' ) ) MyLib.rowClick( $tr[ 0 ], filterContracts );
        }
      } );

    //------------------------------
    $( '#col_r' )
      .find( '#contract_number' )
      .on( 'change', function( ) {
        MyLib.setSession( sessionKey, { contract_number: $( this ).val( ) } );
        window.receiptsSelectCountact( );
        getTableReceipts( );
      } )
      .end( )
      .find( '.btn_create' )
      .on( 'click', function( ) { // нажатие на кнопочку создать
        const $this = $( this );
        MyLib.createDoc(
          $this,
          {
            supplier_order_id: $this.closest( '.clmn' ).data( 'supplier-order-id' ),
            contract_number: $( '#contract_number' ).val( )
          }
        );
      } )
      .end( )
      .on( 'click', 'td, th[data-sort]', function( ) {
        const $this = $( this );
        if ( $this.is( 'th' ) ) {
          MyLib.tableHeaderClick( $this[ 0 ], filterTableReceipt ); // нажатие для сортировки
        } else {
          const $tr = $this.closest( 'tr' );

          if ( !$tr.hasClass( 'selected' ) ) MyLib.rowClick( $tr[ 0 ], null );

          const { 0: button } = $this.children( 'button' );
          if ( button ) {
            const { classList } = button;
            if ( classList.contains( 'btn_del' ) ) MyLib.tableDelClick( button, null );
            else if ( classList.contains( 'btn_view' ) || classList.contains( 'btn_edit' ) ) MyLib.tableEditClick( button );
          }
        }
      } );
  }
} );
