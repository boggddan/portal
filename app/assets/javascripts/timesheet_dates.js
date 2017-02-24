$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#timesheet_dates' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_timesheets' ).addClass( 'active' );

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

  };
});