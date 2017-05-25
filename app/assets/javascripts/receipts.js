$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#receipts' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_receipts' ).addClass( 'active' );

    if ( sessionStorage.receipts_date_start ) { $( '#date_start' ).val( sessionStorage.receipts_date_start ) };
    if ( sessionStorage.receipts_date_end ) { $( '#date_end' ).val( sessionStorage.receipts_date_end ) };
    if ( sessionStorage.receipts_supplier_name ) { $( '#supplier_name' ).val( sessionStorage.receipts_supplier_name ) };
    if ( sessionStorage.receipts_supplier_name_value ) {
      $( '#supplier_name' ).data( 'value', sessionStorage.receipts_supplier_name_value ) };


    $( '#dialog_delete' ).data( 'delete', 'deleteReceipt();' ); // Функция для удаления меню-требования
    $( '#dialog_delete' ).data( 'un-delete', 'unDeleteReceipt();' ); // Отмена удаления меню-требования

    filterTableSupplierOrders(); // Фильтрация таблицы заявок поставщикам

    // Фильтрация таблицы заявок поставщикам
    function filterTableSupplierOrders() {
      var $date_start = $( '#date_start' );
      var $date_end = $( '#date_end' );
      var $supplier_name = $( '#supplier_name' );
      var $contact_number = $( '#contact_number' );

      var $date_start_val = $date_start.val();
      var $date_end_val = $date_end.val();
      var $supplier_name_value = $supplier_name.data( 'value' );

      sessionStorage.receipts_date_start = $date_start_val;
      sessionStorage.receipts_date_end = $date_end_val;
      sessionStorage.receipts_supplier_name = $supplier_name.val();
      sessionStorage.receipts_supplier_name_value = $supplier_name_value;

      var $path_ajax = $date_start.data( 'ajax-path' ) + '?' + $date_start.attr( 'name' ) + '=' + $date_start_val + 
        '&' + $date_end.attr( 'name' ) + '=' + $date_end_val + '&' + $supplier_name.data( 'ajax-param' ) 
        + '=' + $supplier_name_value;
      $.ajax( { url: $path_ajax, type: 'GET', dataType: 'script' } );
    };

    // Выбор заявки поставщику
    selectSupplierOrder = function() {
      var $row = 1;
      if ( sessionStorage.receipts_table_supplier_orders_scroll ) { $( '#table_supplier_orders' ).scrollTop( sessionStorage.receipts_table_supplier_orders_scroll ) };
      if ( sessionStorage.receipts_table_supplier_orders_row ) { $row = sessionStorage.receipts_table_supplier_orders_row };

      $( '#table_supplier_orders tbody tr.selected' ).removeClass( 'selected' );
      $( '#table_supplier_orders tbody tr:nth-of-type( '+ $row +' )' ).addClass( 'selected' );

      filterСontractNumbers(); // Фильтрация списка договоров
    };

    // Очистка заявки поставщику
    emptySupplierOrder = function() {
      var $h1 = $( '.clmn:nth-of-type(2) h1' );
      sessionStorage.removeItem( 'receipts_table_supplier_orders_row' );
      sessionStorage.removeItem( 'receipts_table_supplier_orders_scroll' );
      $h1.text( $h1.data( 'text' ) );
      emptyСontractNumber(); // Очистка договора
    };

    // Фильтрация списка договоров
    filterСontractNumbers = function() {
      var $tr = $( '#table_supplier_orders tbody tr.selected' );
      var $h1 = $( '.clmn:nth-of-type(2) h1' );
      $h1.text( $h1.data( 'text' ) + ' ' + $tr.children( 'td:nth-of-type(2)' ).html() );
      $.ajax( { url: $tr.data( 'ajax-path' ), type: 'GET', dataType: 'script' } );
    };

    // Выбор договора
    selectСontractNumber = function() {
      var $contract_number = $( '#contract_number' );
      var $create_receipt = $( '#create_receipt' );

      if ( sessionStorage.receipts_contract_number ) {
        $contract_number.val( sessionStorage.receipts_contract_number );
        $contract_number.removeClass( 'placeholder' );
        $create_receipt.prop( 'disabled', false );
      } else {
        $contract_number.addClass( 'placeholder' );
        $create_receipt.prop( 'disabled', true );
      };

      filterTableReceipts();
    };

    // Очистка договора
    emptyСontractNumber = function() {
      sessionStorage.removeItem( 'receipts_contract_number' );
      sessionStorage.removeItem( 'receipts_table_receipts_scroll' );
      sessionStorage.removeItem( 'receipts_table_receipts_orders_row' );
      $( '#contract_number' ).val( '' ).prop( 'disabled', true);
      $( '#table_receipts' ).empty();
    };

    // Фильтрация таблицы поступлений
    filterTableReceipts = function() {
      var $contract_number = $( '#contract_number' );
      var $sort = $( '#table_receipts th.sort' );
      console.log($sort.data('name'));
      var $path_ajax = $contract_number.data( 'ajax-path' ) + $( '#table_supplier_orders tbody tr.selected' ).data( 'id' )
        + '&' + $contract_number.attr( 'name' ) + '=' + $contract_number.val() + '&field_sort=date';
      $.ajax( { url: $path_ajax, type: 'GET', dataType: 'script' } );
    };

    // Удаление поступления
    deleteReceipt = function() {
      $.ajax( { url: $( 'tr.delete .btn_del' ).data( 'ajax-path' ), type: 'DELETE', dataType: 'script' } );
      // Если один одна строка, тогда удаляем всю табличку
      if ( $( 'tbody' ).children().length == 1 ) { $( '#table_receipts' ).empty(); } else { $( 'tr.delete' ).remove(); } ;
    };

    // Отмена удаления поступления
    unDeleteReceipt = function() { $( 'tr.delete' ).removeClass( 'delete' ) };

    // Начальная дата фильтрации
    $( '#date_start' ).datepicker( {
      onSelect: function() {
        var $this = $( this );
        var $thisVal = $this.val();
        if ($this.data( 'old-value' ) != $thisVal) {
          var $date_end = $( '#date_end' );
          if ( $thisVal > $date_end.val() ) { $date_end.val( $thisVal ) };
          filterTableSupplierOrders(); // Фильтрация таблицы заявок поставщикам
      } }
    } );

    // Конечная дата фильтрации
    $( '#date_end' ).datepicker( {
      onSelect: function() {
        var $this = $( this );
        var $thisVal = $( this ).val();
        if ( $this.data( 'old-value' ) != $thisVal ) {
          var $date_start = $( '#date_start' );
          if ( $thisVal < $date_start.val() ) { $date_start.val( $thisVal ) };
          filterTableSupplierOrders(); // Фильтрация таблицы заявок поставщикам
      } }
    } );

    // Нажатие на кнопочку создать
    $( '#create_receipt' ).click( function() {
      var $this = $( this );
      $( '#dialog_wait' ).dialog( 'open' );
      var $contract_number = $( '#contract_number' );
      var $path_ajax = $this.data( 'ajax-path' ) + $( '#table_supplier_orders tbody tr.selected' ).data( 'id' )
        + '&' + $contract_number.attr( 'name' ) + '=' + $contract_number.val();
      $.ajax( { url: $path_ajax, type: 'POST', dataType: 'script' } );
    } );

    // Нажатие на ячейке в таблице с заказами
    $( document ).on( 'click', '#table_supplier_orders tbody  tr', function() {
      var $this = $( this );
      if ( !$this.hasClass( 'selected' ) ) {
        sessionStorage.receipts_table_supplier_orders_row = $this.index() + 1;
        sessionStorage.receipts_table_supplier_orders_scroll = $( '#table_supplier_orders' ).scrollTop();
        sessionStorage.removeItem( 'receipts_contract_number' );
        selectSupplierOrder(); // Выбор заявки поставщику
      }
     } );

    // Выбор поставщика со списка выбора
    $( '#supplier_name' ).autocomplete({
      source: $( '#supplier_name' ).data( 'ajax-source' ),
      select: function( event, ui ) {
        var $this = $( this );
        $this.data( 'value', ui.item.value);
        $this.val( ui.item.label );
        filterTableSupplierOrders();
        return false; }
    } );

    // При очистке поставщика отменяем фильтрацию
    $( '#supplier_name' ).keyup( function() {
      var $this = $( this );
      if ( !$this.val() ) {
        $this.data( 'value', '' );
        filterTableSupplierOrders(); }
    } );

    // Выбор со списка договоров, если не выбран договор кнопка создания неактивная
    $( document ).on( 'change', '#contract_number', function() {
      var $this = $( this );
      var $this_val = $this.val();
      if ( $this.val() ) { sessionStorage.receipts_contract_number = $this_val }
        else { sessionStorage.removeItem( 'receipts_contract_number' );
      }

      selectСontractNumber(); // Выбор договора
    } );

    // Нажатие на кнопочку удалить
    $( document ).on( 'click', 'td .btn_del', function() {
      $( this ).parents( 'tr' ).addClass( 'delete' );
      $( '#dialog_delete' ).dialog( 'open' );
    } );

    // Нажатие на кнопочку для перехода заполнения информации
    $( document ).on( 'click', 'td .btn_view, td .btn_edit', function() {
      var $tr = $( this ).parents( 'tr' );
      sessionStorage.receipts_table_receipts_orders_row = $tr.index() + 1;
      sessionStorage.receipts_table_receipts_scroll = $( '#table_receipts' ).scrollTop();
      window.location.replace( $( this ).parents( 'table' ).data( 'path-view' ) + $tr.data( 'id' ) );
    } );

    // Нажатие на кнопочку для перехода заполнения информации
    //$( document ).on( 'click', 'th', function() {
    //} );



  };

} );