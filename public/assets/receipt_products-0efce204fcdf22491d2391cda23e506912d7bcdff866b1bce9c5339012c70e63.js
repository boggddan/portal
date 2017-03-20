$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#receipt_products' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_receipts' ).addClass( 'active' );

    $( 'table' ).tableHeadFixer(); // Фиксируем шапку таблицы
    $( '#date' ).data( 'old-value',  $( '#date' ).val() );
    $( 'h1' ).text( $( 'h1' ).data( 'text' ) + ' ' + $( '#date' ).val() );

    // Заголовок формы Ввода поступлений продуктов
    function receiptUpdate() {
      var $invoice_number = $( '#invoice_number' );
      var $date = $( '#date' );
      var $h1 = $( 'h1' );
      var $dateVal = $date.val();

      $h1.text( $h1.data( 'text' ) + ' ' + $dateVal );

      var $path_ajax = $date.data( 'ajax-path' ) + '&' + $date.attr( 'name' ) + '=' + $dateVal
        + '&' + $invoice_number.attr( 'name' ) + '=' + $invoice_number.val();
      $.ajax( {url: $path_ajax, type: 'POST', dataType: 'script' } );
    };

    // Нажатие на кнопочку отправить
    $( '#send_sa' ).click( function() {
      $( '#dialog_wait' ).dialog( 'open' );
      $.ajax( { url: $( this ).data( 'ajax-path' ), type: 'POST', dataType: 'script' } );
    } );

    // Номер накладной - при потери фокуса сохраняем значение
    $( '#invoice_number' ).blur( function() {
      var $this = $( this );
      if ( $this.data( 'old-value' ) != $this.val() ) { receiptUpdate() }
    } );

    // Номер накладной - при получении фокуса выделяем весь текст
    $( '#invoice_number' ).focus( function() {
      var $this = $( this );
      $this.data( 'old-value', $this.val() ).select();
    } );
    //-------------------------------------------------------------

    //-------------------------------------------------------------
    // Виджет --- Дата накладной - при выборе сохраняем значение
    $( '#date' ).datepicker( {
      onSelect: function() {
        var $this = $( this );
        if ( $this.data( 'old-value' ) != $this.val() ) {  receiptUpdate() };  // Обновление реквизитов и заголовок формы
      } } );
    //-------------------------------------------------------------

    // При получении фокуса выделяем весь текст и сохраянем старое значение
    $( '#table_receipt_products input' ).focus( function() {
      var $this = $( this );
      $this.data( 'old-value', $this.val() ).select();
      $( '#table_receipt_products tr').removeClass( 'selected' );
      $this.parents( 'tr' ).addClass( 'selected' );
    } );

    // Количество товара - при потери фокуса сохраняем значение
    $( '#table_receipt_products input' ).blur( function() {
      var $this = $( this );
      var $thisOldValue = floatValue( $this.data( 'old-value' ) );
      var $thisValue = Math.trunc( floatValue( $this.val() ) * 1000 ) / 1000;

      $this.val( f3_to_s( $thisValue ) );

      if ( $thisOldValue != $thisValue ) {
        $this.data( 'old-value', $thisValue );
        $.ajax( {url: $this.data( 'ajax-path' ) + '&' + $this.attr( 'name' ) + '=' + $thisValue, type: 'POST', dataType: 'script' } ); };
    } );

  };
} );
