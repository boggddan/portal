$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#timesheet_new' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_timesheets' ).addClass( 'active' );

    // Нажатие на кнопочку отправить
    $( '#send_sa' ).click( function() {
      $( '#dialog_wait' ).dialog( $dialogOptions ).dialog( 'open' );
      $.ajax( { url: $( this ).data( 'ajax-path' ), type: 'post', dataType: 'script' } );
    } );

    $( '#date, #date_eb, #date_ee' ).datepicker( );  // Дата

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
    } );
  };
});