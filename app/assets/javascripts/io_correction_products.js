$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#io_correction_products' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_instituiton_orders' ).addClass( 'active' );

    $( 'table' ).tableHeadFixer(); // Фиксируем шапку таблицы
    $( '#date' ).data( 'old-value',  $( '#date' ).val() );
    $( 'h1' ).text( $( 'h1' ).data( 'text' ) + ' ' + $( '#date' ).val() );

    $( '#table_io_correction_products tr td:nth-of-type(3) input' ).each( function() {
      var $this = $( this );
      var $thisVal = $this.val();
      if ( $this.val() ) { $this.addClass( $this.val() > 0 ? 'positive' : 'negative' ) };
    });

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
    $( '#table_io_correction_products input' ).focus( function() {
      var $this = $( this );
      $this.data( 'old-value', $this.val() ).select();
      $( '#table_io_correction_products tr' ).removeClass( 'selected' );
      $this.parents( 'tr' ).addClass( 'selected' );
    } );

    // Количество товара - при изминении пересчитывем значения
    $( '#table_io_correction_products input' ).change( function() {
      var $this = $( this );
      var $thisOldValue = floatValue( $this.data( 'old-value' ) );
      var $thisValue = Math.trunc( floatValue( $this.val() ) * 1000 ) / 1000;

      $this.val( f3_to_s( $thisValue ) );

      if ( $thisOldValue != $thisValue ) {
        $this.data( 'old-value', $thisValue );

        var $name_arr = $this.attr('name').split("_");

        var $diff = $this, $diffVal = $thisValue;
        var $countVal = floatValue( $( '#table_io_correction_products #count_' + $name_arr[1] + '_' + $name_arr[2] ).html() );

        switch ( $name_arr[0] ) {
          case 'diff':
           $( '#table_io_correction_products #result_' + $name_arr[1] + '_' + $name_arr[2] ).val( $countVal + $diffVal );
            break;
          case 'result':
            $diffVal = $thisValue - $countVal;
            var $diff = $( '#table_io_correction_products #diff_' + $name_arr[1] + '_' + $name_arr[2] );
            $diff.val( f3_to_s( $diffVal ) );
            break;
        }

        $diff.removeClass( 'positive negative' );
        if ( $thisValue ) { $this.addClass( $thisValue > 0 ? 'positive' : 'negative' ) };

        $.ajax( {url: $diff.data( 'ajax-path' ) + '&diff=' + $diffVal, type: 'POST', dataType: 'script' } ); };
    } );


  };
});







