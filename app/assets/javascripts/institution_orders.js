$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#institution_orders' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_instituiton_orders' ).addClass( 'active' );

    if ( sessionStorage.instituiton_orders_date_start ) { $( '#date_start' ).val( sessionStorage.instituiton_orders_date_start ) };
    if ( sessionStorage.instituiton_orders_date_end ) { $( '#date_end' ).val( sessionStorage.instituiton_orders_date_end ) };

    filterTableInstituitonOrders(); // Фильтрация таблицы заявок

    // Фильтрация таблицы заявок
    function filterTableInstituitonOrders() {
      var $date_start = $('#date_start');
      var $date_end = $('#date_end');
      var $date_start_val = $date_start.val();
      var $date_end_val = $date_end.val();

      $date_start.data( 'old-value',  $date_start_val );
      $date_end.data( 'old-value',  $date_end );

      sessionStorage.instituiton_orders_date_start = $date_start_val;
      sessionStorage.instituiton_orders_date_end = $date_end_val;

      var $path_ajax = $date_start.data( 'ajax-path' ) + '?' + $date_start.attr( 'name' ) + '=' + $date_start_val + '&' + $date_end.attr( 'name' ) + '=' + $date_end_val;
      $.ajax({ url: $path_ajax, type: 'GET', dataType: 'script' });
    };

    // Выбор заявки
    selectInstitutionOrder = function() {
      var $row = 1 ;

      if ( sessionStorage.instituiton_orders_table_instituiton_orders_scroll ) { $( '#table_instituiton_orders' ).scrollTop( sessionStorage.instituiton_orders_table_instituiton_orders_scroll ) };
      if ( sessionStorage.instituiton_orders_table_instituiton_orders_row ) { $row = sessionStorage.instituiton_orders_table_instituiton_orders_row };

      $( '#table_institution_orders tbody tr.selected' ).removeClass( 'selected' );
      $( '#table_institution_orders tbody tr:nth-of-type(' + $row + ')' ).addClass( 'selected' );

      filterTableIoCorrections(); // Фильтрация таблицы корректировки заявки
    };

    // Очистка заявки
    emptyInstitutionOrder = function() {
      var $h1 = $( '.clmn:nth-of-type(2) h1' );
      sessionStorage.removeItem( 'instituiton_orders_table_instituiton_orders_row' );
      s1essionStorage.removeItem( 'instituiton_orders_table_instituiton_orders_scroll' );
      $h1.text( $h1.data( 'text' ) );
    };

    // Фильтрация таблицы корректировки заявки
    filterTableIoCorrections = function() {
      var $tr = $( '#table_institution_orders tbody tr.selected' );
      var $h1 = $('.clmn:nth-of-type(2) h1');
      $h1.text( $h1.data( 'text' ) + ' ' + $tr.children( 'td:nth-of-type(2)' ).html() );

      var $path_ajax = $h1.data('ajax-path') + $tr.data('id');
      $.ajax({ url: $path_ajax, type: 'GET', dataType: "script" });
    };

    // Удаление заявки
    deleteInstituitonOrder = function() {
      var $path_ajax = $( '#table_institution_orders .table' ).data( 'path-del' ) + $( '#table_institution_orders tr.delete' ).data( 'id' );
      $.ajax( { url: $path_ajax, type: 'DELETE', dataType: 'script' } );

      // Если один одна строка, тогда удаляем всю табличку
      if ( $( '#table_institution_orders tbody' ).children().length == 1 ) { $( '#table_institution_orders' ).empty()
      } else { $( '#table_institution_orders tr.delete' ).remove() } ;
    };

    // Отмена удаления заявки
    unDeleteInstituitonOrder = function() { $( '#table_institution_orders tr.delete' ).removeClass( 'delete' ) };

    // Удаление корректировки заявки
    deleteIoCorrection = function() {
      var $path_ajax = $( '#table_io_corrections .table' ).data( 'path-del' ) + $( '#table_io_corrections tr.delete' ).data( 'id' );
      $.ajax( { url: $path_ajax, type: 'DELETE', dataType: 'script' } );

      // Если один одна строка, тогда удаляем всю табличку
      if ( $( '#table_io_corrections tbody' ).children().length == 1 ) { $( '#table_io_corrections' ).empty()
        } else { $( '#table_io_corrections tr.delete' ).remove() } ;
    };

    // Отмена удаления корректировки заявки
    unDeleteIoCorrection = function() { $( '#table_io_corrections tr.delete' ).removeClass( 'delete' ) };

    // Нажатие на кнопочку создать заявки
    $( '#create_institution_order' ).click( function() {
      $( "#dialog_wait" ).dialog( 'open' );
      var $date_start = $('#date_start');
      var $date_end = $('#date_end');
      var $path_ajax = $( this).data( 'ajax-path' ) + '?' + $date_start.attr( 'name' ) + '=' + $date_start.val() +
        '&' + $date_end.attr( 'name' ) + '=' + $date_end.val();
      $.ajax( { url: $path_ajax, type: 'POST', dataType: 'script' } );
    });

    // Нажатие на кнопочку создать корректировку заявки
    $( '#create_io_correction' ).click( function() {
      $( "#dialog_wait" ).dialog( 'open' );
      $.ajax( { url: $( this ).data( 'ajax-path' ) + $( '#table_institution_orders tbody tr.selected' ).data('id'), type: 'POST', dataType: 'script' } );
    });

    // Начальная дата фильтрации
    $( '#date_start' ).datepicker({
      onSelect: function() {
        var $this = $( this );
        var $thisVal =  $this.val();
        var $date_end = $( '#date_end' );

        if ( $thisVal != $this.data( 'old-value' ) ) {
          if ( $this.datepicker( 'getDate' ) > $date_end.datepicker( 'getDate' ) ) { $date_end.val( $this.val() ) };
          filterTableInstituitonOrders(); // Фильтрация таблицы заявок
        };
      }
    });

    // Конечная дата фильтрации
    $( '#date_end' ).datepicker({
      onSelect: function() {
        var $this = $( this );
        var $thisVal =  $this.val();
        var $date_start = $( '#date_start' );

        if ( $thisVal != $this.data( 'old-value' ) ) {
          if ( $this.datepicker( 'getDate' ) < $date_start.datepicker( 'getDate' ) ) { $date_start.val( $thisVal ) };
          filterTableInstituitonOrders(); // Фильтрация таблицы заявок
        };
      }
    });

    // Нажатие на кнопочку удалить поступление
    $( document ).on( 'click', '#table_institution_orders td .btn_del', function() {
      $( this ).parents( 'tr' ).addClass( 'delete' );
      var dialogDelete = $( '#dialog_delete' )
      dialogDelete.data( 'delete', 'deleteInstituitonOrder();' ); // Функция для удаления заявки
      dialogDelete.data( 'un-delete', 'unDeleteInstituitonOrder();' ); // Отмена удаления заявки
      dialogDelete.dialog( 'open' );
    });

    // Нажатие на кнопочку для перехода заполнения информации
    $( document ).on( 'click', '#table_institution_orders tbody tr', function() {
      var $this = $( this );
      if ( !$this.hasClass('selected') ) {
        sessionStorage.instituiton_orders_table_instituiton_orders_row = $this.index() + 1;
        sessionStorage.instituiton_orders_table_instituiton_orders_scroll = $( '#table_institution_orders' ).scrollTop();
        selectInstitutionOrder(); } // Выбор заявки
    } );

    // Нажатие на кнопочку для перехода заполнения информации
    $( document ).on( 'click', '#table_institution_orders td .btn_view, #table_institution_orders td .btn_edit', function() {
      var $tr = $(this).parents('tr');
      window.location.replace( $( this ).parents( 'table' ).data( 'path-view' ) + $tr.data( 'id' ) );
    } );

    // Нажатие на кнопочку удалить поступление
    $( document ).on( 'click', '#table_io_corrections td .btn_del', function() {
      $( this ).parents( 'tr' ).addClass( 'delete' );
      var dialogDelete = $( '#dialog_delete' )
      dialogDelete.data( 'delete', 'deleteIoCorrection();' ); // Функция для удаления заявки
      dialogDelete.data( 'un-delete', 'unDeleteIoCorrection();' ); // Отмена удаления заявки
      $( '#dialog_delete' ).dialog( 'open' );
    });


    // Нажатие на кнопочку для перехода заполнения информации
    $( document ).on( 'click', '#table_io_corrections td .btn_view, #table_io_corrections td .btn_edit', function() {
      var $tr = $(this).parents('tr');

      sessionStorage.instituiton_orders_table_io_corrections_row = $tr.index() + 1;
      sessionStorage.instituiton_orders_table_io_corrections_scroll = $( '#table_io_corrections' ).scrollTop();
      window.location.replace( $( this ).parents( 'table' ).data( 'path-view' ) + $tr.data( 'id' ) );
    } );

  };

});







