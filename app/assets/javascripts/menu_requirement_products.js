$( document ).on( 'turbolinks:load', ( ) => {
  var scrollbarWidth = getScrollbarWidth();

  // Если объект существует
  const $menuRequirementProducts = $( '#menu_requirement_products' );
  if ( $menuRequirementProducts.length ) {
    const $parentElem = $menuRequirementProducts;

    $( '#main_menu li[data-page=menu_requirements]' ).addClass( 'active' ).siblings(  ).removeClass( 'active' );

    $( '#table_menu_products table' ).tableHeadFixer( { 'left' : 2 } ); // Фиксируем шапку таблицы

    $parentElem
      .find( '#splendingdate' ) // Дата
        .data( 'old-value', $( '#splendingdate' ).val( ) )
        .datepicker( { onSelect: function( ) { сhangeValue( $( this ), 'main', false ); } } )


    // Нажатие на кнопочку отправить
    $( '#send_sap, #send_saf' ).click( function() {
      $( '#dialog_wait' ).dialog( 'open' );
      $.ajax( { url: $( this ).data( 'ajax-path' ), type: 'POST', dataType: 'script' } );
    } );




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
      var $thisOldValue = toDecimal( $this.data( 'old-value' ), 0 );
      var $thisValue = toDecimal( $this.val( ), 0 );

      $this.val( floatToString( $thisValue, 0 ) );

      if ( $thisOldValue != $thisValue ) {
        $this.data( 'old-value' , $thisValue );
        var $name_arr = $this.attr( 'name' ).split( '_' );

        var $countTotal = $( '#table_menu_children_categories #' + $name_arr[0]
          + '_' + $name_arr[1] + '_' + $name_arr[2] + '_total' );

        $countTotal.html( floatToString( toDecimal( $countTotal.html(), 0 ) - $thisOldValue + $thisValue, 0 ) );
        $this.data( 'ajax-blur',
          $this.data( 'ajax-path' ) + '&' + $name_arr[0] + '_' + $name_arr[1] + '_' + $name_arr[2] + '=' + $thisValue ); };
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
      var $thisOldValue = toDecimal( $this.data( 'old-value' ), 3 );
      var $thisValue = toDecimal( $this.val( ), 3 );
      $this.val( floatToString( $thisValue, 3) );

      if ( $thisOldValue != $thisValue ) {
        $this.data( 'old-value', $thisValue );

        var $name_arr = $this.attr('name').split("_");

        var $countType = $name_arr[1];
        var $count = $this, $countValue = $thisValue, $countOldValue = $thisOldValue, $countDiffValue = $thisValue - $thisOldValue;

        switch ( $countType ) {
          case 'diff':
            $countType = 'fact';
            var $count = $( '#table_menu_products #' + $name_arr[0] + '_' + $countType + '_' + $name_arr[2] + '_' + $name_arr[3] + '_' + $name_arr[4] );
            $countOldValue = toDecimal( $count.val(), 3 );
            $countValue = toRound($countOldValue - $thisOldValue + $thisValue, 3);
            console.log($countOldValue, $thisOldValue, $thisValue);
            $count.val( floatToString( $countValue, 3 ) ).data( 'old-value', $countValue );
            $this.removeClass( 'positive' ).removeClass( 'positive' ).addClass( $thisValue > 0 ? 'positive' : 'negative' );
            break;
          case 'fact':
            var $countDiff = $( '#table_menu_products #' + $name_arr[0] + '_diff_' + $name_arr[2] + '_' + $name_arr[3] + '_' + $name_arr[4] );
            var $countDiffInputValue = toDecimal( $countDiff.val( ), 3 ) - $thisOldValue + $thisValue;
            $countDiff.val( floatToString( $countDiffInputValue, 3 ) )
              .removeClass( 'negative' )
              .removeClass( 'positive' )
              .addClass( $countDiffValue > 0 ? 'positive' : 'negative' );
            break;
        }

        var $countAll = $( '#table_menu_products #' + $name_arr[0] + '_' + $countType + '_all_' + $name_arr[2] );
        $countAll.html( floatToString( toDecimal( $countAll.html( ), 3 ) + $countDiffValue, 3 ) );

        var $sumValue = toRound( $countValue * toDecimal( $( '#table_menu_products #price_' + $name_arr[2] ).html( ), 2 ), 2);
        var $sumDiff = $sumValue - toDecimal( $count.data( 'sum' ), 2);
        $count.data( 'sum', floatToString( $sumValue, 2 ) );

        var $childrenCost = $( '#table_menu_children_categories #children_cost_' + $countType + '_' + $name_arr[3] );
        $childrenCost.data( 'sum', floatToString( toDecimal( $childrenCost.data( 'sum' ), 2) + $sumDiff, 2) );

        ChildrenCostCalc( $countType, $name_arr[3] ); // Пересчитать дітодень

        $this.data( 'ajax-blur' , $count.data( 'ajax-path' ) + '&' + $name_arr[0] + '_' + $countType + '=' + $countValue );
      };
    } );

    // Пересчитать дітодень
    function ChildrenCostCalc( $countType, $categoryId ) {
      var $childrenCost = $( '#table_menu_children_categories #children_cost_' + $countType + '_' + $categoryId );
      var $costValue = toDecimal( $( '#table_menu_children_categories #cost_' + $categoryId ).html(), 2 );
      var $childrenDiff = $( '#table_menu_children_categories #children_diff_' + $countType + '_' + $categoryId );
      var $countAllValue = toDecimal( $( '#table_menu_children_categories #count_all_' + $countType + '_' + $categoryId ).val(), 2 );

      var $childrenCostValue = $countAllValue == 0 ? 0 : toRound( toDecimal( $childrenCost.data( 'sum' ), 2 ) / $countAllValue, 2 );
      var $childrenDiffValue = $childrenCostValue - $costValue;

      $childrenCost.html( floatToString( $childrenCostValue, 2 ) );
      $childrenDiff.html( floatToString( $childrenDiffValue, 2 ) )
        .removeClass( 'positive negative' )
        .addClass( $childrenDiffValue > 0 ? 'positive' : 'negative' );
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
