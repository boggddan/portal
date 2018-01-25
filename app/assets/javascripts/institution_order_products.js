/* eslint space-before-function-paren: off, no-invalid-this: off, func-names: off */

$( document ).on( 'turbolinks:load', ( ) => {
  const $insitutionOrderProducts = $( '#institution_order_products' );
  if ( $insitutionOrderProducts.length ) {
    const $parentElem = $insitutionOrderProducts;

    MyLib.mainMenuActive( 'institution_orders' );

    const headerText = ( ) => {
      $( 'h1' ).text( `Заявка №  ${ $( '#number' ).val( ) } від ${ $( '#date' ).val( ) }` );
    };

    headerText( );
    MyLib.tableSetSession( $( '#col_iop .parent_table' ) );

    const changeInstitutionOrder = target => {
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
      .on( 'click', function( ) { MyLib.btnSendClick( $( this ) ) } )
      .end( )
      .find( '.btn_exit, .btn_save' )
      .on( 'click', function( ) { MyLib.btnExitClick( $( this ) ) } )
      .end( )
      .find( '.btn_print' )
      .on( 'click', function( ) { MyLib.btnPrintClick( $( this ) ) } )
      .end( );

    const date = $parentElem[ 0 ].querySelector( '#date' );
    ( { value: date.dataset.oldValue } = date );
    $( date ).datepicker( {
      onSelect( ) {
        changeInstitutionOrder( this );
      }
    } );

    $( '#col_iop' )
      .find( 'tr.row_data' )
      .on( 'click', function( ) {
        const $tr = $( this );
        if ( !$tr.hasClass( 'selected' ) ) MyLib.rowClick( $tr[ 0 ], null );
      } )
      .end( )
      .find( 'tr.date :first-child' )
      .each( function( ) {
        const $this = $( this );
        $this.text( MyLib.capitalize( moment( $this.data( 'value' ) ).format( 'dddd - DD.MM.YY' ) ) );
      } )
      .end( )
      .find( 'tr.row_data input' )
      .each( function( ) { MyLib.initValue( $( this ) ) } )
      .on( 'change', function( ) { MyLib.changeValue( $( this ), 'tr' ) } );
  }
} );
