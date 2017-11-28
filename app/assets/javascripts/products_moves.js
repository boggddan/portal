/* eslint space-before-function-paren: off, no-invalid-this: off, func-names: off */

$( document ).on( 'turbolinks:load', ( ) => {
  const productionMoves = $( '#products_moves' );
  if ( productionMoves.length ) {
    const parentElem = productionMoves;

    const sessionKey = parentElem.attr( 'id' );

    const dateStartSession = ( MyLib.getSession( sessionKey ) ||
      { } ).dateStart || MyLib.toDateFormat( moment( ).startOf( 'month' ) );

    MyLib.setSession( sessionKey, { dateStart: dateStartSession } );

    const dateEndSession = ( MyLib.getSession( sessionKey ) ||
      { } ).dateEnd || MyLib.toDateFormat( moment( ).endOf( 'month' ) );

    MyLib.setSession( sessionKey, { dateEnd: dateEndSession } );

    MyLib.mainMenuActive( sessionKey );

    const getTable = ( ) => {
      const sessionObj = MyLib.getSession( sessionKey );
      const clmn = $( '#col_pm' );
      const { [ clmn.attr( 'id' ) ]: clmnObj } = sessionObj;

      if ( ( sessionObj || { } ).dateStart ) {
        const data = {
          date_start: sessionObj.dateStart,
          date_end: sessionObj.dateEnd,
          sort_field: ( clmnObj || { } ).sortField || '',
          sort_order: ( clmnObj || { } ).sortOrder || ''
        };

        const caption = 'Фільтрація переміщень';
        const url = clmn.data( 'path-filter' );

        MyLib.ajax( caption, url, 'post', data, 'script', null, true );
      }
    };

    const filterTable = ( ) => { // фильтрация таблицы документов
      MyLib.setClearTableSession( sessionKey, 'main' );
      getTable( );
    };

    getTable( ); // запрос таблицы документов

    //----------------
    $( '#col_pm' )
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
      .find( '.btn_create' )
      .on( 'click', function( ) { MyLib.createDoc( $( this ), null ) } )
      .end( )
      .on( 'click', 'td, th[data-sort]', function( ) {
        const $this = $( this );
        if ( $this.is( 'th' ) ) {
          MyLib.tableHeaderClick( $this[ 0 ], filterTable ); // нажатие для сортировки
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
