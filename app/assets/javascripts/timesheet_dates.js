$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#timesheet_dates' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_timesheets' ).addClass( 'active' );

    $( 'table' ).tableHeadFixer(  ); // Фиксируем шапку таблицы
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

    // Дата
    $( '#date_eb, #date_ee' ).datepicker();

    // Нажатие на кнопочку создать
    $( '#create' ).click( function() {
      $( '#dialog_wait' ).dialog( 'open' );
      var $this = $( this );
      var $dateEb = $( '#date_eb' );
      var $dateEe = $( '#date_ee' );
      var $date = $( '#date' );

      var $pathAjax = $this.data( 'ajax-path' ) + '?' + $dateEb.attr( 'name' ) + '=' + $dateEb.val() + '&'
          + $dateEe.attr( 'name' ) + '=' + $dateEe.val() + '&' + $date.attr( 'name' ) + '=' + $date.val()
      $.ajax( { url: $pathAjax, type: 'POST', dataType: 'script' } );
    });

  };
});