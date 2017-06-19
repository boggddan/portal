$( document ).on( 'turbolinks:load', function() {
  var scrollbarWidth = getScrollbarWidth();

  // Если объект существует
  if ( $( '#menu_requirement_products' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_menu_requirements' ).addClass( 'active' );

    $( '#table_menu_products table' ).tableHeadFixer( { 'left' : 2 } ); // Фиксируем шапку таблицы

    // Обновление реквизитов и заголовок формы
    function MenuRequirementUpdate() {
      var $date = $( '#date' );
      var $splendingdate = $( '#splendingdate' );
      var $h1 = $( 'h1' );
      var $date_val = $date.val();
      var $path_ajax = $date.data( 'ajax-path' ) + '&' + $date.attr( 'name' ) + '=' + $date_val + '&' + $splendingdate.attr( 'name' ) + '=' + $splendingdate.val();

      $h1.text( $h1.data( 'text' ) + ' ' + $date_val );
      $.ajax( { url: $path_ajax, type: 'POST', dataType: 'script' } );
    };

    // Нажатие на кнопочку отправить
    $( '#send_sap, #send_saf' ).click( function() {
      $( '#dialog_wait' ).dialog( 'open' );
      $.ajax( { url: $( this ).data( 'ajax-path' ), type: 'POST', dataType: 'script' } );
    } );

    // Дата - при выборе сохраняем значение
    $( '#date, #splendingdate' ).datepicker( {
      onSelect: function() {
        var $this = $( this );
        if ( $this.data( 'old-value' ) != $this.val() ) { MenuRequirementUpdate() };  // Обновление реквизитов и заголовок формы
    } } );

    // При получении фокуса выделяем весь текст и сохраянем старое значение
    $( '#table_menu_children_categories input' ).focus( function() {
      var $this = $( this );
      $this.data( 'old-value', $this.val() ).select();
      $( '#table_menu_children_categories tr' ).removeClass( 'selected' );
      $this.parents( 'tr' ).addClass( 'selected' );
    } );

    // Количество детей - при потери фокуса сохраняем значение
    $( '#table_menu_children_categories input' ).blur( function() {
      var $this = $( this );
      var ajaxBlur = $this.data( 'ajax-blur' );
      if ( ajaxBlur ) {
        $this.data( 'ajax-blur', '' );
        $.ajax( {url: ajaxBlur, type: 'POST', dataType: 'script' } ); }
    } );

    // Количество детей - при потери фокуса сохраняем значение
    $( '#table_menu_children_categories input' ).change( function() {
      var $this = $( this );
      var $thisOldValue = floatValue( $this.data( 'old-value' ) );
      var $thisValue = Math.trunc( floatValue( $this.val() ) );

      $this.val( IntToString( $thisValue ) );

      if ( $thisOldValue != $thisValue ) {
        $this.data( 'old-value' , $thisValue );
        var $name_arr = $this.attr( 'name' ).split( '_' );

        var $countTotal = $( '#table_menu_children_categories #' + $name_arr[0] + '_' + $name_arr[1] + '_' + $name_arr[2] + '_total' );

        $countTotal.html( IntToString(floatValue( $countTotal.html() ) - $thisOldValue + $thisValue ) );
        $this.data( 'ajax-blur', $this.data( 'ajax-path' ) + '&' + $name_arr[0] + '_' + $name_arr[1] + '_' + $name_arr[2] + '=' + $thisValue ); };
        if ( $name_arr[1] = 'all' ) { ChildrenCostCalc( $name_arr[2], $name_arr[3] ) }; // Пересчитать дітодень
    } );

    // При получении фокуса выделяем весь текст и сохраянем старое значение
    $( '#table_menu_products input' ).focus( function() {
      var $this = $( this );
      $this.data( 'old-value', $this.val() ).select();
      $( '#table_menu_products tr').removeClass( 'selected' );
      $this.parents( 'tr' ).addClass( 'selected' );
    } );

    // Количество товара - при потери фокуса сохраняем значение
    $( '#table_menu_products input' ).blur( function() {
      var $this = $( this );
      var ajaxBlur = $this.data( 'ajax-blur' );
      if ( ajaxBlur ) {
        $this.data( 'ajax-blur', '' );
        $.ajax( { url: ajaxBlur, type: 'POST', dataType: 'script' } ); }
    } );

    // Количество товара - при изминении пересчитывем значения
    $( '#table_menu_products input' ).change( function() {
      var $this = $( this );
      var $thisOldValue = floatValue( $this.data( 'old-value' ) );
      var $thisValue = +`${ floatValue( $this.val() ) }`.match(/-?\d+(\.\d{1,3})?/)[0];
      $this.val( $thisValue.toFixed(3) );

      if ( $thisOldValue != $thisValue ) {
        $this.data( 'old-value', $thisValue );

        var $name_arr = $this.attr('name').split("_");

        var $countType = $name_arr[1];
        var $count = $this, $countValue = $thisValue, $countOldValue = $thisOldValue, $countDiffValue = $thisValue - $thisOldValue;

        switch ( $countType ) {
          case 'diff':
            $countType = 'fact';
            var $count = $( '#table_menu_products #' + $name_arr[0] + '_' + $countType + '_' + $name_arr[2] + '_' + $name_arr[3] + '_' + $name_arr[4] );
            $countOldValue = floatValue( $count.val() );
            $countValue = $countOldValue - $thisOldValue + $thisValue;
            $count.val( f3_to_s( $countValue ) ).data( 'old-value', $countValue );
            $this.removeClass( 'positive' ).removeClass( 'positive' ).addClass( $thisValue > 0 ? 'positive' : 'negative' );
            break;
          case 'fact':
            var $countDiff = $( '#table_menu_products #' + $name_arr[0] + '_diff_' + $name_arr[2] + '_' + $name_arr[3] + '_' + $name_arr[4] );
            var $countDiffInputValue = floatValue( $countDiff.val() ) - $thisOldValue + $thisValue;
            $countDiff.val( f3_to_s( $countDiffInputValue ) ).removeClass( 'positive negative' ).removeClass( 'positive' ).addClass( $countDiffValue > 0 ? 'positive' : 'negative' );
            break;
        }

        var $countAll = $( '#table_menu_products #' + $name_arr[0] + '_' + $countType + '_all_' + $name_arr[2] );
        $countAll.html( f3_to_s( floatValue( $countAll.html() ) + $countDiffValue ) );

        var $sumValue = Math.round( $countValue * floatValue( $( '#table_menu_products #price_' + $name_arr[2] ).html() ) * 100 ) / 100;
        var $sumDiff = $sumValue - floatValue( $count.data( 'sum' ) );
        $count.data( 'sum', f2_to_s( $sumValue ) );

        var $childrenCost = $( '#table_menu_children_categories #children_cost_' + $countType + '_' + $name_arr[3] );
        $childrenCost.data( 'sum', f2_to_s( floatValue( $childrenCost.data( 'sum' ) ) + $sumDiff ) );

        ChildrenCostCalc( $countType, $name_arr[3] ); // Пересчитать дітодень

        $this.data( 'ajax-blur' , $count.data( 'ajax-path' ) + '&' + $name_arr[0] + '_' + $countType + '=' + $countValue );
      };
    } );

    // Пересчитать дітодень
    function ChildrenCostCalc( $countType, $categoryId ) {
      var $childrenCost = $( '#table_menu_children_categories #children_cost_' + $countType + '_' + $categoryId );
      var $costValue = floatValue( $( '#table_menu_children_categories #cost_' + $categoryId ).html() );
      var $childrenDiff = $( '#table_menu_children_categories #children_diff_' + $countType + '_' + $categoryId );
      var $countAllValue = floatValue( $( '#table_menu_children_categories #count_all_' + $countType + '_' + $categoryId ).val() );

      var $childrenCostValue = $countAllValue == 0 ? 0 : Math.round( floatValue( $childrenCost.data( 'sum' ) ) / $countAllValue * 100 ) / 100 ;
      var $childrenDiffValue = $childrenCostValue - $costValue;

      $childrenCost.html( f2_to_s( $childrenCostValue ) );
      $childrenDiff.html( f2_to_s( $childrenDiffValue ) ).removeClass( 'positive negative' ).addClass( $childrenDiffValue > 0 ? 'positive' : 'negative' );
    };

    //
    $( 'h2:nth-of-type(1)' ).click( function() {
      $( this ).toggleClass( 'icon_hide icon_show' );
      $( '#table_menu_children_categories' ).slideToggle( function() { productsHeight() } );
    } );

    //
    $( 'h1' ).click( function() {
      $( this ).toggleClass( 'icon_hide icon_show' );
      $( '#panel_main' ).slideToggle( function() { productsHeight() } );
    });

    // Высота таблички с продуктами
    function productsHeight() {
      if ( $( 'h1' ).hasClass( 'icon_show' ) || $( 'h2:nth-of-type(1)' ).hasClass( 'icon_show' ) ) {
        $( '#table_menu_products' ).removeClass( 'min_height' )
        var $tableHeight = $( '#table_menu_products .table' ).height();
        var $tableParentHeight = $(window).height() - $( '#table_menu_products' ).position().top - scrollbarWidth;
        if ($tableHeight > $tableParentHeight) { $( '#table_menu_products' ).height( $tableParentHeight ) };
      } else { $( '#table_menu_products' ).addClass( 'min_height' ) }
    };

  };
} );
