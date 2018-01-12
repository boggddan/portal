/* eslint space-before-function-paren: off, no-invalid-this: off, func-names: off */

$( document ).on( 'turbolinks:load', ( ) => {
  const $institutionOrders = $( '#institution_orders' );
  if ( $institutionOrders.length ) {
    const $parentElem = $institutionOrders;

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
      const $clmn = $( '#col_io' );
      const { [ $clmn.attr( 'id' ) ]: $clmnObj } = $sessionObj;

      if ( ( $sessionObj || { } ).dateStart ) {
        MyLib.ajax(
          'Фільтрація заявки',
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

    const getTableCorrection = ( ) => {
      const $sessionObj = MyLib.getSession( sessionKey );
      const $clmn = $( '#col_ioc' );
      const { [ $clmn.attr( 'id' ) ]: $clmnObj } = $sessionObj;

      const { col_io: $clmnIoObj } = $sessionObj;
      const { rowId: $institutionOrderId } = $clmnIoObj || { };

      if ( $institutionOrderId ) {
        MyLib.ajax(
          'Фільтрація коригування заявки',
          $clmn.data( 'path-filter' ),
          'post',
          {
            institution_order_id: $institutionOrderId,
            sort_field: ( $clmnObj || { } ).sortField || '',
            sort_order: ( $clmnObj || { } ).sortOrder || ''
          },
          'script',
          null,
          true );
      } else {
        $clmn
          .find( '.parent_table' ).empty( )
          .end( )
          .find( 'h1' ).text( $clmn.data( 'captions' ) )
          .end( )
          .find( '.btn_create' )
          .prop( 'disabled', true );
      }
    };

    const filterTableCorrection = ( ) => { // фильтрация таблицы документов
      MyLib.setClearTableSession( sessionKey, 'col_ioc' );
      getTableCorrection( );
    };

    const filterTable = ( ) => { // фильтрация таблицы документов
      MyLib.setClearTableSession( sessionKey, 'col_io' );
      getTable( );
      filterTableCorrection( );
    };

    getTable( ); // запрос таблицы документов
    getTableCorrection( );

    //-----------------
    $( '#col_io' )
      .find( '.btn_create' )
      .on( 'click', function( ) { // нажатие на кнопочку создать
        MyLib.createDoc(
          $( this ),
          { date_start: $( '#date_start' ).val( ), date_end: $( '#date_end' ).val( ) } );
      } )
      .end( )
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

          if ( !$tr.hasClass( 'selected' ) ) MyLib.rowClick( $tr[ 0 ], filterTableCorrection );

          const { 0: button } = $this.children( 'button' );

          if ( button && !button.disabled ) {
            const { classList } = button;
            if ( classList.contains( 'btn_del' ) ) {
              const buttonDel = ( ) => {
                $( '#col_io .btn_create' ).prop( 'disabled', !$( '#col_io table' ).length );
                filterTableCorrection( );
              };

              MyLib.tableDelClick( button, buttonDel );
            } else if ( classList.contains( 'btn_view' ) || classList.contains( 'btn_edit' ) ) MyLib.tableEditClick( button );
          }
        }
      } );

    //---------------------
    $( '#col_ioc' )
      .find( '.btn_create' )
      .on( 'click', function( ) { // нажатие на кнопочку создать
        const $this = $( this );
        MyLib.createDoc(
          $this,
          { institution_order_id: $this.closest( '.clmn' ).data( 'institution-order-id' ) }
        );
      } )
      .end( )
      .on( 'click', 'td, th[data-sort]', function( ) {
        const $this = $( this );
        if ( $this.is( 'th' ) ) {
          MyLib.tableHeaderClick( $this[ 0 ], filterTableCorrection ); // нажатие для сортировки
        } else {
          const $tr = $this.closest( 'tr' );

          if ( !$tr.hasClass( 'selected' ) ) MyLib.rowClick( $tr[ 0 ], null );

          const { 0: button } = $this.children( 'button' );
          if ( button && !button.disabled ) {
            const { classList } = button;
            if ( classList.contains( 'btn_del' ) ) MyLib.tableDelClick( button, null );
            else if ( classList.contains( 'btn_view' ) || classList.contains( 'btn_edit' ) ) MyLib.tableEditClick( button );
          }
        }
      } );
  }
} );
