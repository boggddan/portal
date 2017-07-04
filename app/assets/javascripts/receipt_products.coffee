$( document ).on 'turbolinks:load', ( ) ->

  $receiptProducts = $( '#receipt_products' )
  if $receiptProducts.length
    $parentElem = $receiptProducts

    $( '#main_menu li[data-page=receipt_products ]' ).addClass( 'active' ).siblings(  ).removeClass 'active'

    # Шапка формы
    headerText = -> $( 'h1' ).text "Поставка №  #{ $( '#number' ).val( ) } від #{ $( '#date' ).val( ) }"

    headerText( )
    MyLib.tableSetSession( $( '.clmn .parent_table' ) )

    calcDiff = ( $elem ) ->
      $tr = $elem.closest( 'tr' )
      $countElem = $tr.find( '[name=count]' )
      $count = +$countElem.val( )
      $countInvoice = +$tr.find( '[name=count_invoice]' ).val( )
      $diffElem = $tr.find( '[data-name=diff]' )

      if $elem.attr( 'name' ) is 'count_invoice' and $countInvoice and not $count
        MyLib.changeValue( $countElem.val( $countInvoice ), 'tr', false )
        $diffElem.text( '' )
      else
        MyLib.initValue( $diffElem.text( ($count*1000 - $countInvoice*1000)/1000 ) )

    $parentElem
      .find( 'h1' )
        .click -> MyLib.clickHeader( $( @ ) )
      .end( )
      .find( '.btn_send' )
        .click -> MyLib.btnSendClick( $( @ ) )
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
      .end( )
        .find( '#invoice_number' )   # Дата
          .change ->  MyLib.changeValue( $( @ ), 'main', false )

    $( '.clmn' )
      .find( 'tr.row_data' )
        .click( -> MyLib.rowSelect( $( @ ) ) unless $( @ ).hasClass 'selected' )
      .end( )
      .find( 'tr.date :first-child' )
        .each -> # Отформатировать дату данные
          $this = $( @ )
          $this.text MyLib.capitalize( moment( $this.data 'value' ).format 'dddd - DD.MM.YY' )
      .end( )
      .find( 'tr.row_data td[data-name=diff]' )
        .each -> calcDiff $( @ )
      .end( )
      .find( 'tr.row_data [data-type]' )
        .each -> MyLib.initValue( $( @ ) )
      .end( )
      .find( 'tr.row_data input' )
        .change ->
          MyLib.changeValue( $( @ ), 'tr', false )
          calcDiff $( @ )
      .end( )
      .find( 'tr.row_data select[name=causes_deviation_id]' )
        .change -> MyLib.changeValue( $( @ ), 'tr', false )

