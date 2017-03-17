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
    filterGroupTimesheet(); // Фильтрация категории / группы

    // Нажатие на кнопочку отправить
    $( '#send_sa' ).click( function() {
      $( '#dialog_wait' ).dialog( 'open' );
      $.ajax( { url: $( this ).data( 'ajax-path' ), type: 'post', dataType: 'script' } );
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

    $( '#date_eb, #date_ee' ).datepicker( );  // Дата

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

    // Выбор со списка категории / группы
    $( '#group_timesheet' ).change( function() { filterGroupTimesheet() } ) ; // Фильтрация категории / группы

    // Нажати на ячейку
    $( document ).on( 'click', 'td.tb_mark', function() {
      var $this = $( this );
      if ( !$this.attr( 'disabled' ) ) {
        var $reasonsAbsence = $( '#reasons_absence_'  + $this.data( 'reasons-absence-id' ) );
        var $reasonsAbsenceId = $reasonsAbsence.data( 'next-id' );
        $this.data( 'reasons-absence-id', $reasonsAbsenceId );
        $this.html( $reasonsAbsence.data( 'next-val' ) );
        timesheetDatesUpdate( $this.data( 'id' ), $reasonsAbsenceId ); // Обновление маркера
      }
    } );

    $( document ).on( 'contextmenu', 'td.tb_mark', function( event ) {
      event.preventDefault();
      var $this = $( this );
      if ( $this.html() || !$this.attr('disabled')  ) {
        var $reasonsAbsence = $( '#reasons_absences li:first-child' );
        var $reasonsAbsenceId = $reasonsAbsence.data( 'id' );
        $this.data( 'reasons-absence-id', $reasonsAbsenceId );
        $this.html( $reasonsAbsence.html( ) );
        timesheetDatesUpdate( $this.data( 'id' ), $reasonsAbsenceId ); // Обновление маркера
      }
    } );

  };
});