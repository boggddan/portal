$( document ).on 'turbolinks:load', ( ) ->

  $insitutionOrderProducts = $( '#institution_order_products' )
  if $insitutionOrderProducts.length
    $parentElem = $insitutionOrderProducts

    $( '#main_menu li[data-page=institution_orders ]' ).addClass( 'active' ).siblings(  ).removeClass 'active'

    # Шапка формы
    headerText = -> $( 'h1' ).text "Заявка №  #{ $( '#number' ).val( ) } від #{ $( '#date' ).val( ) }"

    headerText( )
    MyLib.tableSetSession( $( '#col_iop .parent_table' ) )

    $parentElem
      .find( 'h1' )
        .click -> MyLib.clickHeader( $( @ ) )
      .end( )
      .find( '.btn_send' )
        .click -> MyLib.btnSendClick $( @ )  # Нажатие на кнопочку создать
      .end( )
      .find( '.btn_exit, .btn_save' )
        .click -> MyLib.btnExitClick $( @ )
      .end( )
      .find( '.btn_print' )
        .click -> MyLib.btnPrintClick $( @ )
      .end( )
      .find( '#date' )   # Дата
        .data 'old-value', $( '#date' ).val( )
        .datepicker( onSelect: -> MyLib.changeValue( $( @ ), 'main', headerText ) )

    $( '#col_iop' )
      .find( 'tr.row_data' )
        .click( -> MyLib.rowClick( $( @ )[ 0 ], null ) unless $( @ ).hasClass 'selected' )
      .end( )
      .find( 'tr.date :first-child' )
        .each -> # Отформатировать дату данные
          $this = $( @ )
          $this.text MyLib.capitalize( moment( $this.data 'value' ).format 'dddd - DD.MM.YY' )
      .end( )
      .find( 'tr.row_data input' )
        .each -> MyLib.initValue( $( @ ) )
        .change -> MyLib.changeValue( $( @ ), 'tr' )
