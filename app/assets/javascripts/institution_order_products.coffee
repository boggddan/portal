$( document ).on 'turbolinks:load', ( ) ->

  $insitutionOrderProducts = $( '#institution_order_products' )
  if $insitutionOrderProducts.length
    $parentElem = $insitutionOrderProducts

    $( '#main_menu li[data-page=institution_orders ]' ).addClass( 'active' ).siblings(  ).removeClass 'active'

    # Шапка формы
    headerText = -> $( 'h1' ).text "Заявка №  #{ $( '#number' ).val( ) } від #{ $( '#date' ).val( ) }"

    headerText( )
    window.tableSetSession( $( '#col_iop .parent_table' ) )

    $parentElem
    .find( 'h1' )
      .click -> window.clickHeader( $( @ ) )
    .end( )
    .find( '.btn_send' )
      .click -> window.btnSendClick $( @ )  # Нажатие на кнопочку создать
    .end( )
    .find( '.btn_exit, .btn_save' )
      .click -> window.btnExitClick $( @ )
    .end( )
    .find( '#date' )   # Дата
      .data 'old-value', $( '#date' ).val( )
      .datepicker( onSelect: -> сhangeValue( $( @ ), 'main', headerText ) )

    $( '#col_iop' )
      .find( 'tr.row_data' )
        .click( -> window.rowSelect( $( @ ) ) unless $( @ ).hasClass 'selected' )
      .end( )
      .find( 'tr.date :first-child' )
        .each -> # Отформатировать дату данные
          $this = $( @ )
          $this.text window.capitalize( moment( $this.data 'value' ).format 'dddd - DD.MM.YY' )
      .end( )
      .find( 'tr.row_data input' )
        .each -> initValue( $( @ ) )
        .change -> сhangeValue( $( @ ), 'tr' )