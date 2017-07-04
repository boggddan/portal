$( document ).on 'turbolinks:load', ( ) ->

  $ioCorrectionProducts = $( '#io_correction_products' )
  if $ioCorrectionProducts.length
    $parentElem = $ioCorrectionProducts

    $( '#main_menu li[data-page=institution_orders ]' ).addClass( 'active' ).siblings(  ).removeClass 'active'

    # Шапка формы
    headerText = -> $( 'h1' ).text "Коректування заявки №  #{ $( '#number' ).val( ) } від #{ $( '#date' ).val( ) }"

    headerText( )
    MyLib.tableSetSession( $( '#col_iocp .parent_table' ) )

    calcDiff = ( $this ) ->
      $tr = $this.closest( 'tr' )
      $amountOrder = +$tr.children( '[name=amount_order]' ).text( )

      if $this.attr( 'name' ) is 'diff'
        MyLib.changeValue( $this )
        $diff = +$this.val( )
        $amount = $amountOrder + $diff
        $amountElem = $tr.find( '[name=amount]' )
        $amountElem.val( $amount )
        MyLib.changeValue( $amountElem, 'tr' )
      else
        MyLib.changeValue( $this, 'tr' )
        $amount = +$this.val( )
        $diff = $amount - $amountOrder
        $diffElem = $tr.find( '[name=diff]' )
        $diffElem.val( $diff )
        MyLib.changeValue( $diffElem )

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
    .find( '#date' )   # Дата
      .data 'old-value', $( '#date' ).val( )
      .datepicker( onSelect: -> MyLib.changeValue( $( @ ), 'main', headerText ) )

    $( '#col_iocp' )
      .find( 'tr.row_data' )
        .click( -> MyLib.rowSelect( $( @ ) ) unless $( @ ).hasClass 'selected' )
      .end( )
      .find( 'tr.date :first-child' )
        .each -> # Отформатировать дату данные
          $this = $( @ )
          $this.text MyLib.capitalize( moment( $this.data 'value' ).format 'dddd - DD.MM.YY' )
      .end( )
      .find( 'tr.row_data [data-type]' )
        .each -> MyLib.initValue( $( @ ) )
      .end( )
      .find( 'tr.row_data input[name=diff]' )
        .each( ->
          $this = $( @ )
          $this.val()
          $tr = $this.closest( 'tr' )
          $amountOrder = +$tr.children( '[name=amount_order]' ).text( )
          $amount = +$tr.find( '[name=amount]' ).val( )
          $diff = $amount - $amountOrder
          $this.val( $diff ).attr( 'value', $diff )
          MyLib.initValue( $this ) )
        .change -> calcDiff $( @ )
      .end( )
      .find( 'tr.row_data input[name=amount]' )
        .change -> calcDiff $( @ )
