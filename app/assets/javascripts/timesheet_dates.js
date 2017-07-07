class TimesheetDates {

  constructor( parentElem ) {
    const self = this;
    this.rangeData = { minRow: 0, minCell: 0, maxRow: 0, maxCell: 0, prevRow: 0, prevCell: 0 };

    this.parentElem = parentElem;
    this.dataId = parentElem.data( 'id' );
    this.disabled = parentElem.data( 'disabled' );
    this.h1 = parentElem.find( 'h1' );
    this.h1.on( 'click', event => this.clickHeader( event ) );

    this.urlUpdate = this.parentElem.data( 'path-update' );

    this.date = parentElem.find( '#date' );
    this.date
      .prop( 'disabled', this.disabled )
      .datepicker( { onSelect( ) { self.changeTimesheet( this ) } } );

    this.date[ 0 ].dataset.oldValue = this.date.val( );

    this.btnExit = parentElem.find( '.btn_exit' )
      .on( 'click', ( ) => this.clickExit( ) );
    if ( !this.disabled ) this.btnExit.removeClass( 'btn_exit' ).addClass( 'btn_save' );

    this.groupTimesheet = parentElem.find( '#group_timesheet' )
      .on( 'change', event => this.filterGroups( event ) )
      .addClass( 'placeholder' );

    parentElem
      .find( '.btn_send' )
      .prop( 'disabled', this.disabled )
      .on( 'click', event => this.clickSend( event ) )
      .end( )
      .find( '.panel_main button[data-clmn]' )
      .on( 'click', event => this.clickBtnClmn( event ) )
      .end( )
      .find( '.btn_exit' )
      .on('click', ( ) => this.clickExit( ) );

    this.colTd = parentElem.find('#col_td');

    this.urlTbUpdate = this.colTd.data( 'path-update' );
    this.urlTbFilter = this.colTd.data( 'path-filter' );
    this.urlTbUpdates = this.colTd.data( 'path-updates' );

    this.colTd
      .find( 'button[data-reasons-absence-id]' )
      .on( 'click', event => this.clickReasonAbsence( event ) );

    this.colTdParentTable = this.colTd.find( '.parent_table' );

    this.colTdParentTable
      .on( 'click', 'td.cell_mark', event => this.cellMarkClickLeft( event ) )
      .on( 'contextmenu', 'td.cell_mark', event => this.cellMarkClickRight( event ) )
      .on( 'mouseover', 'td, th', event => this.cellMouseOver( event ) )
      .on( 'keydown', 'td.cell_mark:not([disabled])', event => this.cellMarkKeyDown( event ) )
      .on( 'click', 'tr.row_data:not(.selected)', event => this.constructor.clickRow( event ) );

    this.headerText( );
    $( '#main_menu li[data-page=timesheets ]' ).addClass( 'active' ).siblings( ).removeClass( 'active' );

    this.groupTimesheet.change( );
  }

  colTbInit( ) {
    this.colTbTable = this.colTdParentTable.find( 'table' );
    this.colTbTable.tableHeadFixer( { left: 3 } );
    this.calcMarks( );

    this.colTbTable[ 0 ].querySelectorAll( 'th[data-date]' ).forEach( th => {
      const elemTh = th;
      const date = moment( elemTh.dataset.date );
      elemTh.textContent = `${ date.format( 'D' ) } ${ MyLib.capitalize( date.format( 'ddd' ) ) }`;
    } );
  }

  changeTimesheet( target ) {
    const elem = target;
    const { id: nameVal, dataset: { oldValue: valOld }, value: val } = elem;

    if ( val !== valOld ) {
      elem.dataset.oldValue = val;
      const { dataId } = this;
      this.headerText( );
      const captionAjax = `Зміна значення ${ nameVal } з ${ valOld } на ${ val } [id: ${ dataId }]`;
      const dataAjax = { id: dataId, [ nameVal ]: val };

      MyLib.ajax( captionAjax, this.urlUpdate, 'post', dataAjax, 'json', '', false, false );
    }
  }

  // нажатие на кнопочку выход
  clickExit( ) {
    MyLib.pageLoader( true );
    window.location.replace( this.parentElem.data( 'path-exit' ) );
  }

  clickSend( ) {
    MyLib.ajax(
      `Відправка данних в 1С [id: ${ this.dataId }]`,
      this.parentElem.data( 'path-send' ),
      'post',
      { id: this.dataId, bug: '' },
      'json',
      false,
      ( ) => window.location.reload( ),
      true );
  }

  filterGroups( event ) { // фильтрация категории / группы
    const { target: elem } = event;
    const { value } = elem;
    const { dataset: { field: paramName } } = elem.querySelector( 'option:checked' );

    if ( value ) elem.classList.remove( 'placeholder' );
    else elem.classList.add( 'placeholder' );

    MyLib.ajax(
      'Фільтрація данных табеля',
      this.urlTbFilter,
      'post',
      { id: this.dataId, field: paramName, 'field_id': value },
      'script',
      '',
      false,
      true );
  }

  clickReasonAbsence( event ) {
    const { target: elem } = event;
    const { innerHTML: dataVal } = elem;
    const { dataset: { reasonsAbsenceId } } = elem;

    const cells = [ ];

    this.colTbTable[ 0 ].querySelectorAll( 'td.active' ).forEach( td => {
      const tdElem = td;
      if ( tdElem.dataset.reasonsAbsenceId !== reasonsAbsenceId ) {
        cells.push( tdElem.dataset.id );
        tdElem.innerHTML = dataVal;
        tdElem.dataset.reasonsAbsenceId = reasonsAbsenceId;
      }
      tdElem.classList.remove( 'active' );
    } );

    if ( cells.length ) {
      MyLib.ajax(
        'Группова заміна позначок табеля',
        this.urlTbUpdates,
        'post',
        { 'ids': cells, 'reasons_absence_id': reasonsAbsenceId },
        'json',
        '',
        false,
        true );
      this.calcMarks( );
    }
  }

  changeMarkCell( event ) {
    const classActive = 'active';
    const { target: elem, altKey: isAlt } = event;
    const { classList } = elem;

    if ( isAlt ) {
      const rowIndex = elem.parentNode.rowIndex - 1;
      const cellIndex = elem.cellIndex + 1;

      if ( classList.contains( classActive ) ) {
        if ( rowIndex < this.rangeData.prevRow ) this.rangeData.maxRow = Math.min( this.rangeData.maxRow, rowIndex );
        if ( cellIndex < this.rangeData.prevCell ) this.rangeData.maxCell = Math.min( this.rangeData.maxCell, cellIndex );

        if ( rowIndex > this.rangeData.prevRow ) this.rangeData.minRow = Math.max( this.rangeData.minRow, rowIndex );
        if ( cellIndex > this.rangeData.prevCell ) this.rangeData.minCell = Math.max( this.rangeData.minCell, cellIndex );
      } else {
        this.rangeData.minRow = Math.min( this.rangeData.minRow, rowIndex );
        this.rangeData.minCell = Math.min( this.rangeData.minCell, cellIndex );
        this.rangeData.maxRow = Math.max( this.rangeData.maxRow, rowIndex );
        this.rangeData.maxCell = Math.max( this.rangeData.maxCell, cellIndex );
      }

      this.colTbTable[ 0 ]
        .querySelectorAll( 'tbody .active' )
        .forEach( cell => cell.classList.remove( classActive ) );

      this.colTbTable[ 0 ]
        .querySelectorAll( `tbody tr:nth-child(n+${ this.rangeData.minRow }):nth-child(-n+${ this.rangeData.maxRow }) ` +
          `td:nth-child(n+${ this.rangeData.minCell }):nth-child(-n+${ this.rangeData.maxCell })` )
        .forEach( cell => {
          if ( cell.classList.contains( 'cell_mark' ) ) cell.classList.add( classActive );
        } );

      this.rangeData.prevRow = rowIndex;
      this.rangeData.prevCell = cellIndex;
    }
  }

  cellMarkClickLeft( event ) {
    const { target: elem } = event;

    if ( !this.disabled && elem.classList.contains( 'cell_mark' ) && !elem.hasAttribute( 'disabled' ) ) {
      const reasonsAbsence = this.colTd[ 0 ]
        .querySelector( `button[data-reasons-absence-id='${ elem.dataset.reasonsAbsenceId }']` );

      const { dataset: { nextId: raId, nextVal: raVal } } = reasonsAbsence;
      elem.dataset.reasonsAbsenceId = raId;
      elem.textContent = raVal;
      this.markUpdate( elem.dataset.id, raId ); // обновление маркера
      this.calcMarks( );
    }
  }

  cellMarkClickRight( event ) {
    event.preventDefault( );
    const { target: elem } = event;

    if ( !this.disabled && !elem.getAttribute( 'disabled' ) ) {
      const reasonsAbsence = this.colTd[ 0 ].querySelector( 'button[data-reasons-absence-id]' );
      const { dataset: { reasonsAbsenceId } } = reasonsAbsence;
      elem.dataset.reasonsAbsenceId = reasonsAbsenceId;
      elem.innerHTML = '';
      this.markUpdate( elem.dataset.id, reasonsAbsenceId ); // обновление маркера
      this.calcMarks( );
    }
  }

  markUpdate( tbId, reasonsAbsenceId ) { // обновление маркера
    const data = { id: tbId, 'reasons_absence_id': reasonsAbsenceId };
    const caption = `Оновлення позначки табеля id = [ ${ tbId } ]`;
    MyLib.ajax( caption, this.urlTbUpdate, 'post', data, 'json', '', false, false );
  }

  cellMouseOver( event ) {
    event.preventDefault( );
    const { target: elem } = event;
    const { classList } = elem;
    elem.focus( );

    this.changeMarkCell( event );

    if ( !classList.contains( 'hover' ) && !classList.contains( 'name' ) ) {
      this.colTbTable
        .find('.hover').removeClass('hover')
        .end( )
        .find( `tr :nth-child( ${ elem.cellIndex + 1 } )` )
        .addClass( 'hover' );
      elem.classList.add( 'hover' );
    }
  }

  cellMarkKeyDown( event ) {
    event.preventDefault( );
    if ( !event.originalEvent.repeat && !this.disabled && event.altKey ) {
      this.rangeData.minRow = 999999;
      this.rangeData.minCell = 999999;
      this.rangeData.maxRow = 0;
      this.rangeData.maxCell = 0;
      this.rangeData.prevRow = 0;
      this.rangeData.prevCell = 0;

      this.changeMarkCell( event );
    }
  }

  headerText( ) { // шапка формы
    const { value: numberValue } = this.parentElem[ 0 ].querySelector( '#number' );
    this.h1.text( `Табель №  ${ numberValue } від ${ this.date.val( ) }` );
  }

  static clickRow( event ) {
    $( event.currentTarget ).addClass(' selected ').siblings( ).removeClass( 'selected' );
  }

  clickHeader( event ) {
    const elem = $( event.currentTarget );
    elem.toggleClass( 'hide' );
    this.parentElem.find( '.panel_main' ).toggleClass( 'hide' );
  }

  // подсчет итогов
  calcMarks( ) {
    const { colTbTable: { 0: table } } = this;
    table.querySelectorAll( '.cell_day' ).forEach( td => { // очистка все итогов
      const elem = td;
      elem.innerHTML = '';
      elem.dataset.absence = '';
    } );

    const cellSumName = [ 'appearance', 'absence' ];

    table.querySelectorAll( 'tr.row_data' ).forEach( tr => { // по всем строкам с данными
      const sum = [ 0, 0 ];

      const { dataset: { categoryId, groupId, childId } } = tr;

      tr.querySelectorAll( '.cell_mark:not([disabled]' ).forEach( td => {
        const elem = table.querySelector(`#group_${ categoryId }_${ groupId }_${ td.dataset.dateId }`);
        if (td.textContent) {
          sum[ 1 ] += 1;
          elem.dataset.absence = 1 + +elem.dataset.absence;
        } else {
          sum[ 0 ] += 1;
          elem.innerHTML = 1 + +elem.innerHTML;
        }
      } );

      cellSumName.forEach( ( val, i ) => {
        const sumElem = tr.querySelector( `#child_${ categoryId }_${ groupId }_${ childId }_${ val }` );
        sumElem.innerHTML = sum[ i ] || '';
      });
    });

    table.querySelectorAll( 'tr.group' ).forEach( tr => { // по всем строкам групп
      const sum = [ 0, 0 ];

      const { dataset: { categoryId, groupId } } = tr;

      tr.querySelectorAll('.cell_day').forEach( ( td, index ) => {
        const elem = table.querySelector(`#category_${ categoryId }_${ index }`);
        const sumAppearance = +td.innerHTML;
        const sumAbsence = +td.dataset.absence;

        sum[ 0 ] += sumAppearance;
        sum[ 1 ] += sumAbsence;

        if ( sumAbsence ) elem.dataset.absence = sumAbsence + +elem.dataset.absence;
        if ( sumAppearance ) elem.innerHTML = sumAppearance + +elem.innerHTML;
      });

      cellSumName.forEach( ( val, i ) => {
        const elemSum = tr.querySelector( `#group_${ categoryId }_${ groupId }_${ val }` );
        elemSum.innerHTML = sum[ i ] || '';
      });
    });

    table.querySelectorAll( 'tr.category' ).forEach( tr => { // по всем строкам с категорий
      const sum = [ 0, 0 ];

      const { dataset: { categoryId } } = tr;

      tr.querySelectorAll('.cell_day').forEach( ( td, index ) => {
        const elem = table.querySelector( `#all_${ index }` );
        const sumAppearance = +td.innerHTML;
        const sumAbsence = +td.dataset.absence;

        sum[ 0 ] += sumAppearance;
        sum[ 1 ] += sumAbsence;

        if ( sumAbsence ) elem.dataset.absence = sumAbsence + +elem.dataset.absence;
        if ( sumAppearance ) elem.innerHTML = sumAppearance + +elem.innerHTML;
      });

      cellSumName.forEach( ( val, i ) => {
        const elemSum = tr.querySelector( `#category_${ categoryId }_${ val }` );
        elemSum.innerHTML = sum[ i ] || '';
      });
    });

    table.querySelectorAll( 'tr.all' ).forEach( tr => { // по всем строкам итогов
      const sum = [ 0, 0 ];

      tr.querySelectorAll('.cell_day').forEach( td => {
        sum[ 0 ] += +td.innerHTML;
        sum[ 1 ] += +td.dataset.absence;
      } );

      cellSumName.forEach( ( val, i ) => {
        const elemSum = tr.querySelector( `#all_${ val }` );
        elemSum.innerHTML = sum[ i ] || '';
      });
    });
  }

}
