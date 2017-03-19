$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#institution_report_children_day_cost' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_institution_reports' ).addClass( 'active' );

    $( '#date_start' ).data( 'old-value', $( this ).val() );
    $( '#date_end' ).data( 'old-value', $( this ).val() );

  // Начальная дата фильтрации
    $( '#date_start' ).datepicker( {
      onSelect: function() {
        var $this = $( this );
        var $thisVal =  $this.val();
        var $dateEnd = $( '#date_end' );

        if ( $thisVal != $this.data( 'old-value' ) ) {
          if ( $this.datepicker( 'getDate' ) > $dateEnd.datepicker( 'getDate' ) ) {
            $dateEnd.val( $thisVal ).data( 'old-value', $thisVal ) };
          $this.data( 'old-value', $thisVal );
        };
      }
    } );

    // Конечная дата фильтрации
    $( '#date_end' ).datepicker( {
      onSelect: function() {
        var $this = $( this );
        var $thisVal =  $this.val();
        var $dateStart = $( '#date_start' );

        if ( $thisVal != $this.data( 'old-value' ) ) {
          if ( $this.datepicker( 'getDate' ) < $dateStart.datepicker( 'getDate' ) ) {
            $dateStart.val( $thisVal ).data( 'old-value', $thisVal ) };
          $this.data( 'old-value', $thisVal );
        };
      }
    } );

    // Нажатие на кнопочку создать
    $( '#create' ).click( function() {
      $( '#dialog_wait' ).dialog( 'open' );
      var $this = $( this );
      var $dateStart = $( '#date_start' );
      var $dateEnd = $( '#date_end' );

      var $pathAjax = $this.data( 'ajax-path' ) + '?' + $dateStart.attr( 'name' ) + '=' + $dateStart.val()
        + '&' + $dateEnd.attr( 'name' ) + '=' + $dateEnd.val();
      $.ajax( { url: $pathAjax, type: 'post', dataType: 'script' } );
    } );

  };
});