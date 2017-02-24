$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#institution_order_products' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_instituiton_orders' ).addClass( 'active' );

    $( 'table' ).tableHeadFixer(); // Фиксируем шапку таблицы
    $( '#date' ).data( 'old-value',  $( '#date' ).val() );
    $( 'h1' ).text( $( 'h1' ).data( 'text' ) + ' ' + $( '#date' ).val() );

    // Нажатие на кнопочку отправить
    $( '#send_sa' ).click( function() {
      $( '#dialog_wait' ).dialog( 'open' );
      $.ajax( { url: $( this ).data( 'ajax-path' ), type: 'POST', dataType: 'script' } );
    } );

    // Дата
    $( '#date' ).datepicker( {
      onSelect: function() {
        var $this = $( this );
        var $thisVal = $this.val();

        if ( $thisVal != $this.data( 'old-value' ) ) {
          var $h1 = $( 'h1' )
          $h1.text( $h1.data( 'text' ) + ' ' + $thisVal );
          $.ajax( {url: $this.data( 'ajax-path' ) + '&' + $this.attr( 'name' ) + '=' + $thisVal, type: 'POST', dataType: 'script' } ); };
      } } );

    // При получении фокуса выделяем весь текст и сохраянем старое значение
    $( '#table_institution_order_products input' ).focus( function() {
      var $this = $( this );
      $this.data( 'old-value', $this.val() ).select();
      $( '#table_institution_order_products tr' ).removeClass( 'selected' );
      $this.parents( 'tr' ).addClass( 'selected' );
    } );

    // Количество товара - при изминении пересчитывем значения
    $( '#table_institution_order_products input' ).change( function() {
      var $this = $( this );
      var $thisOldValue = floatValue( $this.data( 'old-value' ) );
      var $thisValue = Math.trunc( floatValue( $this.val() ) * 1000 ) / 1000;

      $this.val( f3_to_s( $thisValue ) );

      if ( $thisOldValue != $thisValue ) {
        $this.data( 'old-value', $thisValue );
        $.ajax( {url: $this.data( 'ajax-path' ) + '&' + $this.attr( 'name' ) + '=' + $thisValue, type: 'POST', dataType: 'script' } ); };
    } );
  }
});







