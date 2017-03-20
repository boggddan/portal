$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#timesheets' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_timesheets' ).addClass( 'active' );

    if ( sessionStorage.timesheets_date_start ) { $('#date_start' ).val( sessionStorage.timesheets_date_start ) };
    if ( sessionStorage.timesheets_date_end ) { $( '#date_end' ).val( sessionStorage.timesheets_date_end ) };

    filterTableTimesheets(); // Фильтрация таблицы табелей

    $( '#dialog_delete' ).data( 'delete', 'deleteTimesheet();' ); // Функция для удаления табеля
    $( '#dialog_delete' ).data( 'un-delete', 'unDeleteTimesheet();' ); // Отмена удаления табеля

    // Фильтрация таблицы табелей
    function filterTableTimesheets() {
      var $date_start = $( '#date_start' );
      var $date_end = $( '#date_end' );
      var $date_start_val = $date_start.val();
      var $date_end_val = $date_end.val();

      sessionStorage.timesheets_date_start = $date_start_val;
      sessionStorage.timesheets_date_end = $date_end_val;

      var $path_ajax = $date_start.data( 'ajax-path' ) + '?' + $date_start.attr( 'name' ) + '=' + $date_start_val +
        '&' + $date_end.attr( 'name' ) + '=' + $date_end_val;
      $.ajax( { url: $path_ajax, type: 'GET', dataType: 'script' } );
    };


    // Удаление меню-требования
    deleteTimesheet = function() {
      $.ajax( { url: $( '.table' ).data( 'path-del' ) + $( 'tr.delete' ).data( 'id' ), type: 'delete', dataType: 'script' } );

      // Если один одна строка, тогда удаляем всю табличку
      if ( $( 'tbody' ).children().length == 1 ) { $( '#table_timesheets' ).empty() } else { $( 'tr.delete' ).remove() };
    };

    // Отмена удаления меню-требования
    unDeleteMenuRequirement = function() { $( 'tr.delete' ).removeClass( 'delete' ) };

    // Начальная дата фильтрации
    $( '#date_start' ).datepicker( {
      onSelect: function() {
        var $this = $( this );
        var $thisVal =  $this.val();
        var $date_end = $( '#date_end' );

        if ( $thisVal != $this.data( 'old-value' ) ) {
          if ( $this.datepicker( 'getDate' ) > $date_end.datepicker( 'getDate' ) ) { $date_end.val( $this.val() ) };
          filterTableTimesheets(); // Фильтрация таблицы табелей
        };
      }
    } );

    // Конечная дата фильтрации
    $( '#date_end' ).datepicker({
      onSelect: function() {
        var $this = $( this );
        var $thisVal =  $this.val();
        var $date_start = $( '#date_start' );

        if ( $thisVal != $this.data( 'old-value' ) ) {
          if ( $this.datepicker( 'getDate' ) < $date_start.datepicker( 'getDate' ) ) { $date_start.val( $thisVal ) };
          filterTableTimesheets(); // Фильтрация таблицы табелей
        };
      }
    });

    // Нажатие на кнопочку удалить табель
    $( document ).on( 'click', 'td .btn_del', function() {
      $( this ).parents( 'tr' ).addClass( 'delete' );
      $( '#dialog_delete' ).dialog( 'open' );
    });

    // Нажатие на кнопочку для перехода в документ
    $( document ).on( 'click', 'td .btn_view, td .btn_edit', function() {
      var $tr = $( this ).parents( 'tr' );
      sessionStorage.timesheets_table_row = $tr.index() + 1;
      sessionStorage.timesheets_table_scroll = $( '#table_timesheets' ).scrollTop();
      window.location.replace( $tr.data( 'path-view' ) );
    });

  };
});
