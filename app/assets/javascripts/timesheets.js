$( document ).on( 'turbolinks:load', ( ) => {
  const timesheets = $( '#timesheets' );
  if ( timesheets.length ) {
    const parentElem = timesheets;

    const sessionKey = parentElem.attr( 'id' );

    const dateStartSession = ( MyLib.getSession( sessionKey ) ||
      { } ).dateStart || MyLib.toDateFormat( moment( ).startOf( 'month' ) );

    MyLib.setSession( sessionKey, { dateStart: dateStartSession } );

    const dateEndSession = ( MyLib.getSession( sessionKey ) ||
      { } ).dateEnd || MyLib.toDateFormat( moment( ).endOf( 'month' ) );

    MyLib.setSession( sessionKey, { dateEnd: dateEndSession } );

    $( `#main_menu li[data-page=${ sessionKey }]` ).addClass( 'active' ).siblings(  ).removeClass( 'active' );

    const getTable = ( ) => {
      const sessionObj = MyLib.getSession( sessionKey );
      const clmn = $( '#col_t' );
      const clmnObj = sessionObj[ clmn.attr( 'id' ) ];

      if ( ( sessionObj || { } ).dateStart ) {
        MyLib.ajax(
          'Фільтрація табелів',
          clmn.data( 'path-filter' ),
          'post',
          { date_start: sessionObj.dateStart,
            date_end: sessionObj.dateEnd,
            sort_field: ( clmnObj || { } ).sortField || '',
            sort_order: ( clmnObj || { } ).sortOrder || '' },
          'script',
          null,
          true );
      }
    };

    const filterTable = ( ) => { // Фильтрация таблицы документов
      MyLib.setClearTableSession( sessionKey, 'main' );
      getTable( );
    };

    getTable( ); // Запрос таблицы документов

    ////
    $( '#col_t' )
      .find( '#date_start' ) // Начальная дата фильтрации
      .val( dateStartSession )
      .data( 'old-value', dateStartSession )
      .attr( { readonly: true, placeholder: 'Дата...' } )
      .datepicker( { onSelect: function( ) { MyLib.selectDateStart( $( this ), '#date_end', filterTable ) } } )
      .end( )
      .find( '#date_end' ) // Конечная дата фильтрации
      .val( dateEndSession )
      .data( 'old-value', dateEndSession )
      .attr( { readonly: true, placeholder: 'Дата...' } )
      .datepicker( { onSelect: function( ) { MyLib.selectDateEnd( $( this ), '#date_start', filterTable ) } } )
      .end( )
      .find( '.btn_create' )
      .on( 'click', ( ) => MyLib.assignLocation( $('#col_t').data( 'path-new' ) ) )
      .end( )
      .on( 'click', 'td, th[data-sort]' , function( ) {
        const elem = $( this );
        if ( elem.is( 'th' ) ) {
          MyLib.tableHeaderClick( elem[ 0 ] , filterTable ); // Нажатие для сортировки
        } else {
          const tr = elem.closest( 'tr' );
          if ( !tr.hasClass( 'selected' ) ) MyLib.rowClick( tr[ 0 ], null );

          const { 0: button } = elem.children( 'button' );
          const { classList } = button;
          if ( classList.contains( 'btn_del' ) ) MyLib.tableDelClick( button, null );
          else if ( classList.contains( 'btn_view' ) || classList.contains( 'btn_edit' ) ) MyLib.tableEditClick( button );
        }
      } );
  }
} );
