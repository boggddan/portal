/* eslint space-before-function-paren: off, no-invalid-this: off, func-names: off */

$( document ).on( 'turbolinks:load', ( ) => {
  const $timesheetNew = $( '#timesheet_new' );
  if ( $timesheetNew.length ) {
    const $parentElem = $timesheetNew;

    const sessionKey = $parentElem.attr( 'id' );

    const dateStartSession = ( MyLib.getSession( sessionKey ) ||
      { } ).dateStart || MyLib.toDateFormat( moment( ).startOf( 'month' ) );

    MyLib.setSession( sessionKey, { dateStart: dateStartSession } );

    const dateEndSession = ( MyLib.getSession( sessionKey ) ||
      { } ).dateEnd || MyLib.toDateFormat( moment( ).endOf( 'month' ) );

    MyLib.setSession( sessionKey, { dateEnd: dateEndSession } );

    MyLib.mainMenuActive( 'timesheets' );

    //-----------------------------
    $( '#col_t' )
      .find( '#date_start' ) // начальная дата фильтрации
      .val( dateStartSession )
      .data( 'old-value', dateStartSession )
      .attr( { readonly: true, placeholder: 'Дата...' } )
      .datepicker( { onSelect( ) { MyLib.selectDateStart( $( this ), '#date_end', false ) } } )
      .end( )
      .find( '#date_end' ) // конечная дата фильтрации
      .val( dateEndSession )
      .data( 'old-value', dateEndSession )
      .attr( { readonly: true, placeholder: 'Дата...' } )
      .datepicker( { onSelect( ) { MyLib.selectDateEnd( $( this ), '#date_start', false ) } } )
      .end( )
      .find( '.btn_create' )
      .on( 'click', function( ) { // нажатие на кнопочку создать
        MyLib.createDoc(
          $( this ),
          { date_start: $( '#date_start' ).val( ), date_end: $( '#date_end' ).val( ) }
        );
      } )
      .end( )
      .find( '.btn_exit' )
      .on( 'click', ( ) => { MyLib.assignLocation( $( '#col_t' ).data( 'path-exit' ) ) } )
      .end( );
  }
} );
