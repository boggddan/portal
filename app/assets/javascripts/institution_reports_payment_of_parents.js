/* eslint space-before-function-paren: off, no-invalid-this: off, func-names: off */

$( document ).on( 'turbolinks:load', ( ) => {
  const paymentOfParents = $( '#payment_of_parents' );
  if ( paymentOfParents.length ) {
    const parentElem = paymentOfParents;

    const sessionKey = parentElem.attr( 'id' );

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
    parentElem
      .find( '.btn_create, .btn_print' )
      .on( 'click', function( ) { // нажатие на кнопочку создать
        const { value: dateStart } = document.getElementById( 'date_start' );
        const { value: dateEnd } = document.getElementById( 'date_end' );
        const { value: typeSearch } = document.getElementById( 'type_search' );
        const { value: codeSearch } = document.getElementById( 'code_search' );
        const isPdf = this.classList.contains( 'btn_print' );
        const data = {
          date_start: dateStart,
          date_end: dateEnd,
          type_search: typeSearch,
          code_search: codeSearch,
          is_pdf: isPdf
        };

        const { [ 0 ]: { dataset: { pathView: url } } } = parentElem;
        const caption = 'Формування звіта в ІС';
        MyLib.ajax( caption, url, 'post', data, 'json', null, true );
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
