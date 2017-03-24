$( document ).on( 'turbolinks:load', function( ) {

  // Если объект существует
  if ( $( '#receipt_products' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_receipts' ).addClass( 'active' );

    function HeaderText( ) { // Заголовок
      $( 'h1' ).text( 'Поставка № ' + $( '#number' ).val( ) + ' від ' + $( '#date' ).val( ) );
    };

    function CountDiff( $tr ) { // Пересчитать отклонение
      var $countInvoice = float3Value( $tr.children( 'td' ).children( '#count_invoice' ).val( ) );
      var $count = float3Value( $tr.children( 'td' ).children( '#count' ).val( ) );
      var $value =  $count - $countInvoice;
      $tr.children('.count_diff').html( f3_to_s( $value ) )
        .removeClass( 'positive negative' ).addClass( $value > 0 ? 'positive' : 'negative' );
    };

    $( 'table' ).tableHeadFixer( ); // Фиксируем шапку таблицы
    var $disabledInput = $( '#date_sa' ).length ? true : false ;
    HeaderText( ); // Заголовок

    // Пересчитать таблицу с продуктами и проставить отклонение и сохранить значения для ввода количества
    $( '#table_receipt_products tbody tr.row_data' ).each( function( ) {
      var $this = $( this );
      var $inputCount = $this.children( 'td' ).children( '#count' );
      var $inputCountValue = float3Value( $inputCount.val( ) );
      $inputCount.val( f3_to_s( $inputCountValue ) ).data( 'old-value', $inputCountValue )
        .prop( 'disabled', $disabledInput );

      var $inputCountInvoice = $this.children( 'td' ).children( '#count_invoice' );
      var $inputCountInvoiceValue = float3Value( $inputCountInvoice.val( ) );
      $inputCountInvoice.val( f3_to_s( $inputCountInvoiceValue ) ).data( 'old-value', $inputCountInvoiceValue )
        .prop( 'disabled', $disabledInput );
      
      CountDiff( $this );
    } );

    function ReceiptUpdate( $elem ) { // Обновление реквизитов документа
      $elem.data( 'old-value', $elem.val( ) );
      HeaderText( );
      var $receiptProducts = $( '#receipt_products' );
      var $pathUpdate = $receiptProducts.data( 'path-update' )+ '?id=' + $receiptProducts.data( 'id' )
        + '&' + $elem.attr( 'name' ) + '=' + $elem.val( );
      $.ajax( { url: $pathUpdate, type: 'post', dataType: 'script' } );
    };
    
    function ReceiptProductUpdate( $elem ) { // Обновление реквизитов табличной части
      $elem.data( 'old-value', $elem.val() );
      var $id = $elem.parents( 'tr' ).data( 'id' );
      var $pathUpdate = $elem.parents( 'table' ).data( 'path-update' )+ '?id=' + $elem.parents( 'tr' ).data( 'id' )
        + '&' + $elem.attr( 'name' ) + '=' + $elem.val( );
      $.ajax( { url: $pathUpdate, type: 'post', dataType: 'script' } );
    };
    
    $( '#send_sa' ).prop( 'disabled', $disabledInput )
      .click( function( ) { // Нажатие на кнопочку отправить
        $( '#dialog_wait' ).dialog( 'open' );
        var $pathSend = $( this ).data( 'path-send' )+ '?id=' + $( '#receipt_products' ).data( 'id' );
        $.ajax( { url: $pathSend, type: 'post', dataType: 'script' } );
      } );

    $( '#exit' ).addClass( $disabledInput ? 'btn_exit' : 'btn_save' )
      .click( function( ) { window.location.href = $( this ).data( 'path-redirect' ) } ); // Нажатие на кнопочку выход
    
    $( '#invoice_number' ).prop( 'disabled', $disabledInput ) // Номер накладной
      .data( 'old-value', $( '#invoice_number' ).val( ) )
      .blur( function( ) { // при потери фокуса сохраняем значение
        var $this = $( this );
        if ( $this.data( 'old-value' ) != $this.val( ) ) { ReceiptUpdate( $this ) }
      } )
      .focus( function( ) { $( this ).select( ) } ); // при получении фокуса выделяем весь текст
    
    $( '#date' ).data( 'old-value',  $( '#date' ).val( ) ).prop( 'disabled', $disabledInput ) // Дата накладной 
      .datepicker( {
        onSelect: function( ) { // при выборе сохраняем значение
          var $this = $( this );
          if ( $this.data( 'old-value' ) != $this.val( ) ) { ReceiptUpdate( $this ) };
      } } );

    $( '#table_receipt_products input' ) // Количество
      .focus( function( ) { // 
        $( '#table_receipt_products tr').removeClass( 'selected' );
        $( this ).parents( 'tr' ).addClass( 'selected' );
      } )
      .blur( function( ) { // Количество товара - при потери фокуса сохраняем значение
        var $this = $( this );
        var $thisValue = float3Value( $this.val( ) );
        $this.val( f3_to_s( $thisValue ) );
  
        if ( $this.data( 'old-value' ) != $thisValue ) {
          ReceiptProductUpdate( $this ); // Обновление реквизитов табличной части
          CountDiff( $this.parents( 'tr' ) );
        };
      } );

    $( '#table_receipt_products select' ) // Количество
      .focus( function( ) { //
        $( '#table_receipt_products tr').removeClass( 'selected' );
        $( this ).parents( 'tr' ).addClass( 'selected' );
      } )
      .change( function( ) { // Количество товара - при потери фокуса сохраняем значение
        var $this = $( this );
        if ( $this.data( 'old-value' ) != $this.val( ) ) {  ReceiptProductUpdate( $this ) };// Обновление реквизитов табличной части
      } );

  };
} );