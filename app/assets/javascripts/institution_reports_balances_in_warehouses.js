/* eslint space-before-function-paren: off, no-invalid-this: off, func-names: off */

$( document ).on( 'turbolinks:load', ( ) => {

  const elemBalancesInWarehouses = document.getElementById( 'balances_in_warehouses' );
  if ( elemBalancesInWarehouses ) {
    const parentElem = elemBalancesInWarehouses;

    const { id: sessionKey } = parentElem;

    const dateStartSession = ( MyLib.getSession( sessionKey ) ||
      { } ).dateStart || MyLib.toDateFormat( moment( ).startOf( 'month' ) );

    MyLib.setSession( sessionKey, { dateStart: dateStartSession } );

    const dateEndSession = ( MyLib.getSession( sessionKey ) ||
      { } ).dateEnd || MyLib.toDateFormat( moment( ).endOf( 'month' ) );

    MyLib.setSession( sessionKey, { dateEnd: dateEndSession } );

    //-------------------
    parentElem
      .querySelectorAll( '.btn_create, .btn_print' ).forEach( elem => {
        elem.addEventListener( 'click', event => {
          const caption = 'Формування звіта в ІС';
          const data = {
            date_start: parentElem.querySelector( '#date_start' ).value,
            date_end: parentElem.querySelector( '#date_end' ).value,
            is_pdf: event.currentTarget.classList.contains( 'btn_print' ),
            show_amount: parentElem.querySelector( '#show_amount' ).checked,
            show_period: parentElem.querySelector( '#show_period' ).checked
          };

          const { dataset: { pathView: url } } = parentElem;
          MyLib.ajax( caption, url, 'post', data, 'json', null, true );
        } );
      } );

    const dateStart = parentElem.querySelector( '#date_start' );
    dateStart.value = dateStartSession;
    dateStart.readonly = true;
    dateStart.placeholder = 'Дата...';
    ( { value: dateStart.dataset.oldValue } = dateStart );
    $( dateStart ).datepicker( { onSelect( ) { MyLib.selectDateStart( $( this ), '#date_end', false ) } } );

    const dateEnd = parentElem.querySelector( '#date_end' );
    dateEnd.value = dateEndSession;
    dateEnd.readonly = true;
    dateEnd.placeholder = 'Дата...';
    ( { value: dateEnd.dataset.oldValue } = dateEnd );
    $( dateEnd ).datepicker( { onSelect( ) { MyLib.selectDateEnd( $( this ), '#date_start', false ) } } );
  }
} );
