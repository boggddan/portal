/* eslint space-before-function-paren: off, no-invalid-this: off, func-names: off */

$( document ).on( 'turbolinks:load', ( ) => {
  const $ioCorrectionProducts = $( '#io_correction_products' );
  if ( $ioCorrectionProducts.length ) {
    const $parentElem = $ioCorrectionProducts;

    MyLib.mainMenuActive( 'institution_orders' );

    // шапка формы
    const headerText = ( ) => {
      $( 'h1' ).text( `Коректування заявки №  ${ $( '#number' ).val( ) } від ${ $( '#date' ).val( ) }` );
    };

    headerText( );
    MyLib.tableSetSession( $( '#col_iocp .parent_table' ) );

    const calcDiff = $this => {
      const $tr = $this.closest( 'tr' );
      const $amountOrder = +$tr.children( '[name=amount_order]' ).text( );

      let $diff = 0;
      let $amount = 0;

      if ( $this.attr( 'name' ) === 'diff' ) {
        MyLib.changeValue( $this );
        $diff = +$this.val( );
        $amount = MyLib.toRound( $amountOrder + $diff, 3 );
        const $amountElem = $tr.find( '[name=amount]' );
        $amountElem.val( $amount );
        MyLib.changeValue( $amountElem, 'tr' );
      } else {
        MyLib.changeValue( $this, 'tr' );
        $amount = +$this.val( );
        $diff = MyLib.toRound( $amount - $amountOrder, 3 );
        const $diffElem = $tr.find( '[name=diff]' );
        $diffElem.val( $diff );
        MyLib.changeValue( $diffElem );
      }
    };

    const changeIoCorrention = target => {
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
      .end( );

    const date = $parentElem[ 0 ].querySelector( '#date' );
    ( { value: date.dataset.oldValue } = date );
    $( date ).datepicker( {
      onSelect( ) {
        changeIoCorrention( this );
      }
    } );

    $( '#col_iocp' )
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
      .find( 'tr.row_data [data-type]' )
      .each( function( ) { MyLib.initValue( $( this ) ) } )
      .end( )
      .find( 'tr.row_data input[name=diff]' )
      .each( function( ) {
        const $this = $( this );
        $this.val( );
        const $tr = $this.closest( 'tr' );
        const $amountOrder = +$tr.children( '[name=amount_order]' ).text( );
        const $amount = +$tr.find( '[name=amount]' ).val( );
        const $diff = MyLib.toRound( $amount - $amountOrder, 3 );
        $this.val( $diff ).attr( 'value', $diff );
        MyLib.initValue( $this );
      } )
      .on( 'change', function( ) { calcDiff( $( this ) ) } )
      .end( )
      .find( 'tr.row_data input[name=amount]' )
      .on( 'change', function( ) { calcDiff( $( this ) ) } );
  }
} );
