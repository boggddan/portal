$( document ).on( 'turbolinks:load', ( ) => {

  const $timesheetDates = $( '#timesheet_dates' );
  if ( $timesheetDates.length ) {
    const $parentElem = $timesheetDates;

    $( '#main_menu li[data-page=timesheets ]' ).addClass( 'active' ).siblings(  ).removeClass( 'active' );

    const dateSa = document.getElementById( '#date_sa' );
    const dateSaVal = dateSa ? dateSa.value : '';

    const filterTimesheetDates = ( ) => { // Фильтрация категории / группы
      const $groupTimesheet = $( '#group_timesheet' );
      const $groupTimesheetVal = $groupTimesheet.val( );
      const $paramName = $groupTimesheet.children( 'option:selected' ).data( 'field' );

      if ( $groupTimesheetVal ) {
        $groupTimesheet.removeClass( 'placeholder' );
      } else {
        $groupTimesheet.addClass( 'placeholder' );
      }

      window.ajax(
        'Фільтрація данных табеля',
        $('.clmn').data( 'path-filter' ),
        'post',
        { id: $parentElem.data( 'id' ), field: $paramName, field_id: $groupTimesheetVal },
        'script',
        '',
        false,
        true );
    };

    const headerText = ( ) => // Шапка формы
      $( 'h1' ).text( `Табель №  ${ $( '#number' ).val( ) } від ${ $( '#date' ).val( ) }` );

    const captionDatesUpdate = 'Оновлення позначки табеля';
    const urlDatesUpdate = document.querySelector('.clmn').dataset.pathUpdate;

    const timesheetDatesUpdate = ( timesheetDatesId, reasonsAbsenceId ) => { // Обновление маркера
      const data = { id: timesheetDatesId, reasons_absence_id: reasonsAbsenceId };
      window.ajax( captionDatesUpdate, urlDatesUpdate, 'post', data, 'json', '', false, false );
    };

    const classActive = 'active';
    const cursorVal = 'cell';

    const changeCell = ( $this, $event ) => {
      const [isCtrl, isAlt] = [ $event.ctrlKey, $event.altKey ];
      if ( isCtrl || isAlt ) {
        $this.css( {cursor: cursorVal } );
        if ( isCtrl && !$this.hasClass( classActive ) ) $this.addClass( classActive );
        if ( isAlt && $this.hasClass( classActive ) ) $this.removeClass( classActive );
      }
    };

    headerText( ); // Шапка формы
    filterTimesheetDates( ); // Фильтрация категории / группы

    $parentElem
      .find( 'h1' )
      .on( 'click', function( ) { window.clickHeader( $( this ) ); } )
      .end( )
      .find( '.btn_send' )
      .on( 'click', function( ) { window.btnSendClick( $( this ) ); } )  // Нажатие на кнопочку создать
      .end( )
      .find( '.btn_exit, .btn_save' )
      .on( 'click', function( ) { window.btnExitClick( $( this ) ); } )
      .end( )
      .find( '#date' ) // Дата
      .data( 'old-value', $( '#date' ).val( ) )
      .datepicker( { onSelect: function( ) { сhangeValue( $( this ), 'main', headerText ); } } )
      .end( )
      .find( '#group_timesheet' )
      .on( 'change', ( ) => filterTimesheetDates( ) )
      .end( )
      .find( '.reasons_absence' )
      .on( 'click', function( ) {
        const $this = $( this );
        const dataVal = $this.text( );
        const dataId = $this.data( 'id' );

        let cells = []

        $('.parent_table td.active').each( function( ) {
          const td = $( this );
          if ( td.text( ) !== dataVal ) {
            cells.push( td.data( 'id' ));
            td.text( dataVal ).data( 'reasons-absence-id', dataId );
          }
          td.removeClass( 'active' );
        } );

        if ( cells.length ) {
          window.ajax(
            'Группова заміна позначок табеля',
            $('.clmn').data( 'path-group-update' ),
            'post',
            { 'ids': cells, reasons_absence_id: dataId },
            'json',
            '',
            false,
            true );
          timesheetSumAll( );
        }
      } )
      .end( )
      .find('.parent_table')
      .on( 'click', 'td', function( ) {
        const $this = $( this );
        if ( !dateSaVal && $this.hasClass( 'cell_mark' ) && !$this.attr( 'disabled' ) ) {
          const reasonsAbsence = $( `.reasons_absence[data-id='${ $this.data('reasons-absence-id') }']` );
          const reasonsAbsenceId = reasonsAbsence.data( 'next-id' );
          $this.data( 'reasons-absence-id', reasonsAbsenceId );
          $this.text( reasonsAbsence.data( 'next-val' ) );
          timesheetDatesUpdate( $this.data( 'id' ), reasonsAbsenceId ); // Обновление маркера
          timesheetSumAll( );
        }
      } )
      .on( 'contextmenu', 'td.cell_mark', function( e ) {
        e.preventDefault( );
        const $this = $( this );
        if ( !dateSaVal && !$this.attr( 'disabled' ) ) {
          const reasonsAbsence = $( '.reasons_absence:first-child' );
          const reasonsAbsenceId = reasonsAbsence.data( 'id' );
          $this.data( 'reasons-absence-id', reasonsAbsenceId );
          $this.text( '' );
          timesheetDatesUpdate( $this.data( 'id' ), reasonsAbsenceId ); // Обновление маркера
          timesheetSumAll( );
        }
      } )
      .on( 'mouseover', 'td, th', function( e ) {
        const $this = $( this );
        e.preventDefault( );
        $this.focus( );
        if ( $this.hasClass( 'cell_mark' ) && !$this.attr( 'disabled' ) ) {
          changeCell( $( this ), e );
        }

        if ( !$this.hasClass( 'hover' ) ) {
          $this.closest( 'table' )
            .find('.hover').removeClass('hover')
            .end()
            .find(`tr :nth-child( ${$this.index()+1 } )`)
            .addClass('hover');
          $this.addClass( 'hover' );
        }
      } )
      .on( 'mouseout', 'td', function( ) {
        const $this = $( this );
        if ( $this.hasClass( 'cell_mark' ) && !$this.attr( 'disabled' ) ) {
          $this.css( { cursor: '' } );
          $this.blur();
        }
      } )
      .on( 'keydown', 'td.cell_mark:not([disabled])', function( e ) {
        e.preventDefault( );
        changeCell( $( this ), e );
      } )
      .on( 'keyup', 'td.cell_mark:not([disabled])', function() {
        $( this ).css( { cursor: '' } );
      } )
      .on( 'click', 'tr.row_data:not(.selected)', function( ) {
        $( this ).addClass(' selected ').siblings( ).removeClass( 'selected' );
      } ) ;
  }
} );

// Подсчет итогов
const timesheetSumAll = ( ) => {
  const table = document.querySelector('table');
  table.querySelectorAll( '.cell_day' ).forEach( (td) => {// Очистка все итогов
    td.innerHTML = '';
    td.dataset.absence = '';
  } );

  const cellSumName = [ 'appearance', 'absence' ];

  table.querySelectorAll( 'tr.row_data' ).forEach( (tr) => { // По всем строкам с данными
    const sum = [ 0, 0 ];

    const categoryId = tr.dataset.categoryId;
    const groupId = tr.dataset.groupId;
    const childId = tr.dataset.childId;

    tr.querySelectorAll('.cell_mark:not([disabled]').forEach( (td) => {
      const elem = table.querySelector(`#group_${ categoryId }_${ groupId }_${ td.dataset.dateId }`);
      if (td.textContent) {
        sum[ 1 ] += 1;
        elem.dataset.absence = 1 + +elem.dataset.absence;
      } else {
        sum[ 0 ] += 1;
        elem.innerHTML = 1 + +elem.innerHTML;
      }
    });

    cellSumName.forEach( ( v, i ) => {
      tr.querySelector( `#child_${ categoryId }_${ groupId }_${ childId }_${ v }` ).innerHTML = sum[ i ] || '' ;
    });
  });

  table.querySelectorAll( 'tr.group' ).forEach( (tr) => { // По всем строкам групп
    const sum = [ 0, 0 ];

    const categoryId = tr.dataset.categoryId;
    const groupId = tr.dataset.groupId;

    tr.querySelectorAll('.cell_day').forEach( (td, index) => {
      const elem = table.querySelector(`#category_${ categoryId }_${ index }`);
      const sumAppearance = +td.innerHTML;
      const sumAbsence = +td.dataset.absence;

      sum[ 0 ] += sumAppearance
      sum[ 1 ] += sumAbsence

      if ( sumAbsence ) elem.dataset.absence = sumAbsence + +elem.dataset.absence;
      if ( sumAppearance ) elem.innerHTML = sumAppearance + +elem.innerHTML;
    });

    cellSumName.forEach( ( v, i ) => {
      tr.querySelector( `#group_${ categoryId }_${ groupId }_${ v }` ).innerHTML = sum[ i ] || '' ;
    });
  });

  table.querySelectorAll( 'tr.category' ).forEach( (tr) => { // По всем строкам с категорий
    const sum = [ 0, 0 ];

    const categoryId = tr.dataset.categoryId;

    tr.querySelectorAll('.cell_day').forEach( (td, index) => {
      const elem = table.querySelector(`#all_${ index }`);
      const sumAppearance = +td.innerHTML;
      const sumAbsence = +td.dataset.absence;

      sum[ 0 ] += sumAppearance
      sum[ 1 ] += sumAbsence

      if ( sumAbsence ) elem.dataset.absence = sumAbsence + +elem.dataset.absence;
      if ( sumAppearance ) elem.innerHTML = sumAppearance + +elem.innerHTML;
    });

    cellSumName.forEach( ( v, i ) => {
      tr.querySelector( `#category_${ categoryId }_${ v }` ).innerHTML = sum[ i ] || '' ;
    });
  });

  table.querySelectorAll( 'tr.all' ).forEach( (tr) => { // По всем строкам итогов
    const sum = [ 0, 0 ];

    tr.querySelectorAll('.cell_day').forEach( (td) => {
      sum[ 0 ] += +td.innerHTML;
      sum[ 1 ] += +td.dataset.absence;
    });

    cellSumName.forEach( ( v, i ) => {
      tr.querySelector( `#all_${ v }` ).innerHTML = sum[ i ] || '' ;
    });
  });
};
