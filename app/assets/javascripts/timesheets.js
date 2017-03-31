$( document ).on( 'turbolinks:load', function( ) {

  // Если объект существует
  if ( $( '#timesheets' ).length ) {
    var $sessionKey = 'timesheets';
    var $sessionTableKey = 'table_timesheets';

    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_timesheets' ).addClass( 'active' );

    // Функция для удаления ( Отмена удаления) табеля )
    $( '#dialog_delete' ).data( 'delete', 'deleteTimesheet( )' ).data( 'un-delete', 'unDeleteTimesheet( )' );

    function filterTableTimesheets( ) { // Фильтрация таблицы табелей
      var $dateStartKey = 'date_start';
      var $dateEndKey = 'date_end';
      var $sortFieldKey = 'sort_field';
      var $sortOrderKey = 'sort_order';

      var $dateStartValue = GetSession( $sessionKey, $dateStartKey );
      var $dateEndValue = GetSession( $sessionKey, $dateEndKey );
      var $sortFieldValue = GetSession( $sessionKey, $sortFieldKey );
      var $sortOrderValue = GetSession( $sessionKey, $sortOrderKey );

      var $path = $( '#timesheets' ).data( 'path-filter' )
        + '?' + $dateStartKey + '=' + $dateStartValue + '&' + $dateEndKey + '=' + $dateEndValue
        + '&' + $sortFieldKey + '=' + $sortFieldValue + '&' + $sortOrderKey + '=' + $sortOrderValue;
      $.ajax( { url: $path, type: 'get', dataType: 'script' } );
    };

    filterTableTimesheets( ); // Фильтрация таблицы табелей

    deleteTimesheet = function( ) { // Удаление табеля
      var $path =  $( 'table' ).data( 'path-del' ) + '?id=' + $( 'tr.delete' ).data( 'id' );
      $.ajax( { url: $path, type: 'delete', dataType: 'script' } );
      // Если один одна строка, тогда удаляем всю табличку
      if ( $( 'tbody' ).children( ).length == 1 ) { $( 'table' ).remove( ) } else { $( 'tr.delete' ).remove( ) };
    };

    unDeleteTimesheet = function( ) { $( 'tr.delete' ).removeClass( 'delete' ) }; // Отмена удаления табеля

    // Начальная дата фильтрации
    $( '#date_start' ).val( GetSession( $sessionKey, 'date_start' ) )
      .datepicker( {
        onSelect: function( ) {
          var $this = $( this );
          var $thisVal =  $this.val( );
          var $dateEnd = $( '#date_end' );
  
          if ( $thisVal != $this.data( 'old-value' ) ) {
            $this.data( 'old-value', $thisVal );
            SetSession( $sessionKey, 'date_start', $thisVal );
  
            if ( !$dateEnd.val( ) || $this.datepicker( 'getDate' ) > $dateEnd.datepicker( 'getDate' ) ) {
              $dateEnd.val( $thisVal ).data( 'old-value', $thisVal );
              SetSession( $sessionKey, 'date_end', $thisVal );
            };
  
            filterTableTimesheets( ); // Фильтрация таблицы табелей
          };
        }
      } );

    // Конечная дата фильтрации
    $( '#date_end' ).val( GetSession( $sessionKey, 'date_end' ) )
      .datepicker( {
        onSelect: function( ) {
          var $this = $( this );
          var $thisVal =  $this.val( );
          var $dateStart = $( '#date_start' );
  
          if ( $thisVal != $this.data( 'old-value' ) ) {
            $this.data( 'old-value', $thisVal );
            SetSession( $sessionKey, 'date_end', $thisVal );
  
            if ( !$dateStart.val( ) || $this.datepicker( 'getDate' ) < $dateStart.datepicker( 'getDate' ) ) {
              $dateStart.val( $thisVal ).data( 'old-value', $thisVal );
              SetSession( $sessionKey, 'date_start', $thisVal );
            };
  
            filterTableTimesheets( ); // Фильтрация таблицы табелей
          };
        }
      } );

    $( '#timesheets' ).on( 'click', 'td .btn_del', function( ) { // Нажатие на кнопочку удалить табель
      $( this ).parents( 'tr' ).addClass( 'delete' );
      $( '#dialog_delete' ).dialog( 'open' );
    } );

    $( '#timesheets' ).on( 'click', 'td .btn_view, td .btn_edit', function( ) {  // Нажатие на кнопочку для перехода в документ
      var $this = $( this );
      var $trId = $this.parents( 'tr' ).data( 'id' );

      SetSession( $sessionTableKey, 'scroll', $( '#table_timesheets' ).scrollTop( ) );
      SetSession( $sessionTableKey, 'row_id', $trId );
      window.location.replace( $this.parents( 'table' ).data( 'path-view' ) + '?id=' + $trId );
    } );

    // Создание документа
    $( '.btn_create' ).click( function( ) { window.location.replace( $( '#timesheets' ).data( 'path-new' ) ) } );

    $( document ).on( 'click', 'th[id]', function( ) { // Нажатие для сортировки
      var $this = $( this );
      var $sortOrder = 'asc';

      if ( $this.hasClass( 'sort_asc' ) || $this.hasClass( 'sort_desc' ) ) {
        if ( $this.hasClass( 'sort_asc' ) ) {
          $this.removeClass( 'sort_asc' ).addClass( 'sort_desc' );
          $sortOrder = 'desc';
        } else { $this.removeClass( 'sort_desc' ).addClass( 'sort_desc' ) }
      } else { $this.addClass( 'sort_asc' ) };

      SetSession( $sessionKey, 'sort_field', $this.attr( 'id' ) );
      SetSession( $sessionKey, 'sort_order', $sortOrder );
      filterTableTimesheets( );
    } );

  };
} );