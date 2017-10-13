/* eslint space-before-function-paren: off, no-invalid-this: off, func-names: off */

$( document ).on( 'turbolinks:load', ( ) => {
  const $attendanceOfChildren = $( '#attendance_of_children' );
  if ( $attendanceOfChildren.length ) {
    const $parentElem = $attendanceOfChildren;

    const sessionKey = $parentElem.attr( 'id' );

    const dateStartSession = ( MyLib.getSession( sessionKey ) ||
      { } ).dateStart || MyLib.toDateFormat( moment( ).startOf( 'month' ) );

    MyLib.setSession( sessionKey, { dateStart: dateStartSession } );

    const dateEndSession = ( MyLib.getSession( sessionKey ) ||
      { } ).dateEnd || MyLib.toDateFormat( moment( ).endOf( 'month' ) );

    MyLib.setSession( sessionKey, { dateEnd: dateEndSession } );

    const childrenGroupSession = ( MyLib.getSession( sessionKey ) ||
    { } ).childrenGroup || '';

    MyLib.setSession( sessionKey, { childrenGroup: childrenGroupSession } );

    //-----------------
    $parentElem
      .find( '.btn_create, .btn_print' )
      .on( 'click', function( ) { // нажатие на кнопочку создать
        const $dateStart = $( '#date_start' );
        const $dateEnd = $( '#date_end' );
        const $childrenGroupCode = $( '#children_group_code' );
        MyLib.ajax(
          'Формування табеля в ІС',
          $parentElem.data( 'path-view' ),
          'post',
          {
            date_start: $dateStart.val( ),
            date_end: $dateEnd.val( ),
            children_group_code: $childrenGroupCode.val( ),
            is_pdf: $( this ).hasClass( 'btn_print' )
          },
          'json',
          null,
          true );
      } )
      .end( )
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
      .find( '#children_group_code' ) // конечная дата фильтрации
      .val( childrenGroupSession )
      .on( 'change', function( ) { MyLib.setSession( sessionKey, { childrenGroup: $( this ).val( ) } ) } )
      .end( );
  }
} );
