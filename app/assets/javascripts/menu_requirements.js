$( document ).on( 'turbolinks:load', ( ) => {
  const $menuRequirements = $( '#menu_requirements' );
  if ( $menuRequirements.length ) {
    const $parentElem = $menuRequirements;

    const $sessionKey = $parentElem.attr( 'id' );
    const $dateStartSession = ( MyLib.getSession( $sessionKey ) || { } ).date_start;
    const $dateEndSession = ( MyLib.getSession( $sessionKey ) || { } ).date_end;

    $( `#main_menu li[data-page=${ $sessionKey }]` ).addClass( 'active' ).siblings(  ).removeClass( 'active' );

    const getTable = ( ) => {
      const $sessionObj = MyLib.getSession( $sessionKey );
      const $clmn = $( '#col_mr' );
      const $clmnObj = $sessionObj[ $clmn.attr( 'id' ) ];

      if ( ( $sessionObj || { } ).date_start ) {
        MyLib.ajax(
          'Фільтрація табелів',
          $clmn.data( 'path-filter' ),
          'post',
          { date_start: $sessionObj.date_start,
            date_end: $sessionObj.date_end,
            sort_field: ( $clmnObj || { } ).sort_field,
            sort_order: ( $clmnObj || { } ).sort_order },
          'script' );
      };
    };

    const filterTable = ( ) => { // Фильтрация таблицы документов
      MyLib.setClearTableSession( $sessionKey, 'main' );
      getTable( );
    };

    getTable( ); // Запрос таблицы документов

    ////
    $( '#col_mr' )
      .find( '#date_start' ) // Начальная дата фильтрации
        .val( $dateStartSession )
        .data( 'old-value', $dateStartSession )
        .attr( { readonly: true, placeholder: 'Дата...' } )
        .datepicker( { onSelect: function( ) { MyLib.selectDateStart( $( this ), '#date_end', filterTable ); } } )
      .end( )
      .find( '#date_end' ) // Конечная дата фильтрации
        .val( $dateEndSession )
        .data( 'old-value', $dateEndSession )
        .attr( { readonly: true, placeholder: 'Дата...' } )
        .datepicker( { onSelect: function( ) { MyLib.selectDateEnd( $( this ), '#date_start', filterTable ); } } )
      .end( )
      .find( '.btn_create' )
        .on( 'click', function( ) { MyLib.createDoc( $( this ), { } ); } )
      .end( )
      .on( 'click', 'td, th[data-sort]' , function( ) {
        const $this = $( this );
        if ( $this.is( 'th' ) ) {
          MyLib.tableHeaderClick( $this, filterTable ); // Нажатие для сортировки
        } else {
          const $button = $this.children( 'button' );
          const $tr = $this.closest( 'tr' );

          if ( !$tr.hasClass( 'selected' ) ) MyLib.rowSelect( $tr );

          if ( $button.length ) MyLib.tableButtonClick( $button, false );
        };
      } );
  };
} );
