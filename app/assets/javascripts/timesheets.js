$( document ).on( 'turbolinks:load', ( ) => {
  const $timesheets = $( '#timesheets' );
  if ( $timesheets.length ) {
    const $parentElem = $timesheets;

    const $sessionKey = $parentElem.attr( 'id' );
    const $dateStartSession = ( window.getSession( $sessionKey ) || { } ).date_start;
    const $dateEndSession = ( window.getSession( $sessionKey ) || { } ).date_end;

    $( `#main_menu li[data-page=${ $sessionKey }]` ).addClass( 'active' ).siblings(  ).removeClass( 'active' );

    const getTable = ( ) => {
      const $sessionObj = window.getSession( $sessionKey );
      const $clmn = $( '#col_t' );
      const $clmnObj = $sessionObj[ $clmn.attr( 'id' ) ];

      if ( ( $sessionObj || { } ).date_start ) {
        window.ajax(
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
      setClearTableSession( $sessionKey, 'main' );
      getTable( );
    };

    getTable( ); // Запрос таблицы документов

    ////
    $( '#col_t' )
      .find( '#date_start' ) // Начальная дата фильтрации
        .val( $dateStartSession )
        .data( 'old-value', $dateStartSession )
        .attr( { readonly: true, placeholder: 'Дата...' } )
        .datepicker( { onSelect: function( ) { window.selectDateStart( $( this ), '#date_end', filterTable ); } } )
      .end( )
      .find( '#date_end' ) // Конечная дата фильтрации
        .val( $dateEndSession )
        .data( 'old-value', $dateEndSession )
        .attr( { readonly: true, placeholder: 'Дата...' } )
        .datepicker( { onSelect: function( ) { window.selectDateEnd( $( this ), '#date_start', filterTable ); } } )
      .end( )
      .find( '.btn_create' )
        .on( 'click', ( ) => assignLocation( $('#col_t').data( 'path-new' ) ) )
      .end( )
      .on( 'click', 'td, th[data-sort]' , function( ) {
        const $this = $( this );
        if ( $this.is( 'th' ) ) {
          window.tableHeaderClick( $this, filterTable ); // Нажатие для сортировки
        } else {
          const $button = $this.children( 'button' );
          const $tr = $this.closest( 'tr' );

          if ( !$tr.hasClass( 'selected' ) ) window.rowSelect( $tr );

          if ( $button.length ) window.tableButtonClick( $button, false );
        };
      } );
  };
} );
