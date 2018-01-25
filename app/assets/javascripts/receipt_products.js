/* eslint space-before-function-paren: off, no-invalid-this: off, func-names: off */

$( document ).on( 'turbolinks:load', ( ) => {
  const $receiptProducts = $( '#receipt_products' );
  if ( $receiptProducts.length ) {
    const $parentElem = $receiptProducts;

    MyLib.mainMenuActive( 'receipts' );

    // шапка формы
    const headerText = ( ) => {
      $( 'h1' ).text( `Поставка №  ${ $( '#number' ).val( ) } від ${ $( '#date' ).val( ) }` );
    };

    headerText( );
    MyLib.tableSetSession( $( '.clmn .parent_table' ) );

    const calcDiff = $elem => {
      const $tr = $elem.closest( 'tr' );
      const $countElem = $tr.find( '[name=count]' );
      const $count = +$countElem.val( );
      const $countInvoice = +$tr.find( '[name=count_invoice]' ).val( );
      const $diffElem = $tr.find( '[data-name=diff]' );

      if ( $elem.attr( 'name' ) === 'count_invoice' && $countInvoice && !$count ) {
        MyLib.changeValue( $countElem.val( $countInvoice ), 'tr', false );
        $diffElem.text( '' );
      } else {
        MyLib.initValue( $diffElem.text( MyLib.toRound( $count - $countInvoice, 2 ) ) );
      }
    };

    const changeReceipt = target => {
      const elem = target;
      const { id: nameVal, dataset: { oldValue: valOld }, value: val } = elem;

      if ( val !== valOld ) {
        const { [ 0 ]: mainElem } = $parentElem;
        const { dataset: { id: dataId } } = mainElem;

        const data = { id: dataId, [ nameVal ]: val };
        const caption = `Зміна значення ${ nameVal } з ${ valOld } на ${ val } [id: ${ dataId }]`;
        const { dataset: { pathUpdate: url } } = mainElem;
        ( async () => {
          const result = await MyLib.ajax( caption, url, 'post', data, 'json', null, true );
          if ( result.status ) elem.dataset.oldValue = val;
          else {
            elem.value = valOld;
            elem.setAttribute( 'value', valOld );
          }
        } )( );
      }
    };

    $parentElem
      .find( 'h1' )
      .on( 'click', function( ) { MyLib.clickHeader( $( this ) ) } )
      .end( )
      .find( '.btn_send' )
      .on( 'click', function( ) {
        const { value: valueInvoiceNumber }  = $parentElem[ 0 ].querySelector( '#invoice_number' );
        if ( valueInvoiceNumber ) {
          MyLib.btnSendClick( $( this ) );
        } else {
          const caption =  'Не заповнений номер накладної';
          objFormSplash.open( 'error', caption, caption );
        }
      } )
      .end( )
      .find( '.btn_exit, .btn_save' )
      .on( 'click', function( ) { MyLib.btnExitClick( $( this ) ) } )
      .end( );

    const date = $parentElem[ 0 ].querySelector( '#date' );
    ( { value: date.dataset.oldValue } = date );
    $( date ).datepicker( {
      onSelect( ) {
        changeReceipt( this );
      }
    } );

    const invoiceNumber = $parentElem[ 0 ].querySelector( '#invoice_number' );
    ( { value: invoiceNumber.dataset.oldValue } = invoiceNumber );
    invoiceNumber.addEventListener( 'click', event => changeReceipt( event.currentTarget ) );

    $( '.clmn' )
      .find( 'tr.row_data' )
      .on( 'click', function( ) {
        if ( !$( this ).hasClass( 'selected' ) ) MyLib.rowClick( $( this )[ 0 ], null );
      } )
      .end( )
      .find( 'tr.date :first-child' )
      .each( function( ) { // отформатировать дату данные
        const $this = $( this );
        $this.text( MyLib.capitalize( moment( $this.data( 'value' ) ).format( 'dddd - DD.MM.YY' ) ) );
      } )
      .end( )
      .find( 'tr.row_data td[data-name=diff]' )
      .each( function( ) { calcDiff( $( this ) ) } )
      .end( )
      .find( 'tr.row_data [data-type]' )
      .each( function( ) { MyLib.initValue( $( this ) ) } )
      .end( )
      .find( 'tr.row_data input' )
      .on( 'change', function( ) {
        MyLib.changeValue( $( this ), 'tr', false );
        calcDiff( $( this ) );
      } )
      .end( )
      .find( 'tr.row_data select[name=causes_deviation_id]' )
      .on( 'change', function( ) { MyLib.changeValue( $( this ), 'tr', false ) } );
  }
} );
