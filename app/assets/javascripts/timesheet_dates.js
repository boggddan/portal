$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#timesheet_dates' ).length ) {

    filterGroupTimesheet = function( ) { // Фильтрация категории / группы
      var $groupTimesheet = $( '#group_timesheet' );
      var $groupTimesheetVal = $groupTimesheet.val( );
      var $paramName = $groupTimesheet.children( 'option:selected' ).data( 'field' );

      if ( $groupTimesheetVal ) { $groupTimesheet.removeClass( 'placeholder' ) }
      else ( $groupTimesheet.addClass( 'placeholder' ) );

      var $path_ajax = $groupTimesheet.data( 'ajax-path' ) + $groupTimesheet.data('param-name') + '=' + $paramName +
        '&' + $groupTimesheet.data('param-id') + '=' + $groupTimesheetVal;

      $.ajax( { url: $path_ajax, type: 'get', dataType: 'script' } );
    };

    timesheetDatesUpdate = function( $timesheetDatesId, $reasonsAbsenceId ) { // Обновление маркера
      var $table = $( '#table_timesheet_dates .table' );
      var $path_ajax = $table.data( 'path-update' ) + $timesheetDatesId
        + '&' + $table.data('param-name') + '=' + $reasonsAbsenceId;
      $.ajax( { url: $path_ajax, type: 'post', dataType: 'script' } );
    };


    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_timesheets' ).addClass( 'active' );

    $( '#date' ).data( 'old-value',  $( '#date' ).val() );
    $( 'h1' ).text( $( 'h1' ).data( 'text' ) + ' ' + $( '#date' ).val() );

    // Нажатие на кнопочку отправить
    $( '#send_sa' ).click( function() {
      $( '#dialog_wait' ).dialog( 'open' );
      $.ajax( { url: $( this ).data( 'ajax-path' ), type: 'post', dataType: 'script' } );
    } );

    if( $( '#group_timesheet' ).length ) { filterGroupTimesheet() } // Фильтрация категории / группы

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

    // Выбор со списка категории / группы
    $( '#group_timesheet' ).change( function() { filterGroupTimesheet() } ) ; // Фильтрация категории / группы

  };
});