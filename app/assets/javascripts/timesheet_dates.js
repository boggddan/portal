/* exported TimesheetDates */

class TimesheetDates {
  constructor( elem ) {
    const self = this;
    const parentElem = elem;

    const disabled = parentElem.dataset.disabled === 'true';

    const date = parentElem.querySelector( '#date' );
    ( { value: date.dataset.oldValue } = date );
    date.disabled = disabled;
    $( date ).datepicker( { onSelect( ) { self.changeTimesheet( this ) } } );

    const btnExit = parentElem.querySelector( '.btn_exit' );
    btnExit.addEventListener( 'click', ( ) => this.clickExit( ) );

    if ( !disabled ) {
      btnExit.classList.remove( 'btn_exit' );
      btnExit.classList.add( 'btn_save' );
    }

    parentElem.querySelector( 'h1' ).addEventListener( 'click', event => this.clickHeader( event.currentTarget ) );

    const groupTimesheet = parentElem.querySelector( '#group_timesheet' );
    groupTimesheet.addEventListener( 'change', event => this.filterGroups( event ) );

    const btnSend = parentElem.querySelector( '.btn_send' );
    btnSend.disabled = disabled;
    btnSend.addEventListener( 'click', ( ) => this.clickSend( ) );

    const btnRefresh = parentElem.querySelector( '.btn_refresh' );
    btnRefresh.disabled = disabled;
    btnRefresh.addEventListener( 'click', ( ) => this.clickRefresh( ) );

    const colTd = parentElem.querySelector( '#col_td' );

    parentElem.querySelectorAll( 'button[data-reasons-absence-id]' ).forEach( child => {
      const elemChild = child;
      elemChild.disabled = disabled;
      elemChild.addEventListener( 'click', event => this.clickReasonAbsence( event ) );
    } );

    const colTdParentTable = colTd.querySelector( '.parent_table' );

    colTdParentTable.addEventListener( 'click', event => {
      if ( event.target.matches( 'td.cell_mark' ) ) {
        this.cellMarkClickLeft( event.target );
        event.stopPropagation();
      }

      const tr = event.target.closest( ' tr ' );
      if ( tr && tr.matches( '.row_data:not(.selected)' ) ) {
        this.constructor.clickRow( tr );
        event.stopPropagation();
      }
    } );

    colTdParentTable.addEventListener( 'contextmenu', event => {
      if ( event.target.matches( 'td.cell_mark' ) ) {
        this.cellMarkClickRight( event );
        event.stopPropagation();
      }
    } );

    colTdParentTable.addEventListener( 'mouseover', event => {
      if ( event.target.matches( 'td.cell_mark' ) ) {
        this.cellMouseOver( event );
        event.stopPropagation();
      }
    } );

    colTdParentTable.addEventListener( 'keydown', event => {
      if ( event.target.matches( 'td.cell_mark' ) ) {
        this.cellMarkKeyDown( event );
        event.stopPropagation();
      }
    } );

    parentElem.querySelectorAll( 'input[data-date]' ).forEach( child => {
      const elemChild = child;
      elemChild.value = MyLib.toDateFormat( elemChild.dataset.date );
    } );

    const menuItem = document.querySelector( '#main_menu li[data-page=timesheets]' );
    if ( menuItem ) {
      Array.from( menuItem.parentElement.children ).forEach( child => {
        const { classList } = child;
        if ( child === menuItem ) classList.add( 'active' ); else classList.remove( 'active' );
      } );
    }

    [ this.dataId, this.disabled ] = [ +parentElem.dataset.id, disabled ];

    [ this.parentElem, this.colTd, this.colTdParentTable ] = [ parentElem, colTd, colTdParentTable ];

    this.rangeData = { minRow: 0, minCell: 0, maxRow: 0, maxCell: 0, prevRow: 0, prevCell: 0 };
    this.reasonsAbsences = JSON.parse( this.parentElem.dataset.reasonsAbsences || '[ ]' );

    this.headerText( );
    groupTimesheet.dispatchEvent( new Event( 'change' ) );
  }

  colTbInit( elements ) {
    this.colTdParentTable.innerHTML = elements;
    this.colTbTable = this.colTdParentTable.querySelector( 'table' );
    $( this.colTbTable ).tableHeadFixer( { left: 3 } );

    this.colTbTable.querySelectorAll( 'th[data-date]' ).forEach( th => {
      const elemTh = th;
      const date = moment( elemTh.dataset.date );
      elemTh.textContent = `${ date.format( 'D' ) } ${ MyLib.capitalize( date.format( 'ddd' ) ) }`;
    } );

    this.colTbTable.querySelectorAll( 'td.cell_mark' ).forEach( child => {
      const elemChild = child;
      if ( !this.reasonsAbsences.includes( +elemChild.dataset.reasonsAbsenceId ) ) {
        elemChild.setAttribute( 'disabled', true );
      }
    } );

    this.calcMarks( );
  }

  changeTimesheet( target ) {
    const elem = target;
    const { id: nameVal, dataset: { oldValue: valOld }, value: val } = elem;

    if ( val !== valOld ) {
      elem.dataset.oldValue = val;
      const { dataId } = this;
      this.headerText( );
      const caption = `Зміна значення ${ nameVal } з ${ valOld } на ${ val } [id: ${ dataId }]`;
      const data = { id: dataId, [ nameVal ]: val };
      const { parentElem: { dataset: { pathUpdate: url } } } = this;
      MyLib.ajax( caption, url, 'post', data, 'json', null, false );
    }
  }

  // нажатие на кнопочку выход
  clickExit( ) {
    MyLib.pageLoader( true );
    window.location.replace( this.parentElem.dataset.pathExit );
  }

  clickSend( ) {
    const caption = `Відправка данних в 1С [id: ${ this.dataId }]`;
    const { parentElem: { dataset: { pathSend: url } } } = this;
    const data = { id: this.dataId };
    const successAjax = ( ) => window.location.reload( );
    MyLib.ajax( caption, url, 'post', data, 'json', successAjax, true );
  }

  clickRefresh( ) {
    const caption = `Оновлення данних з 1С [id: ${ this.dataId }]`;
    const { parentElem: { dataset: { pathRefresh: url } } } = this;
    const data = { id: this.dataId };
    const successAjax = ( ) => window.location.reload( );
    MyLib.ajax( caption, url, 'post', data, 'json', null, true );
  }

  filterGroups( event ) { // фильтрация категории / группы
    const { target: elem } = event;
    const { value } = elem;
    const { dataset: { field: paramName } } = elem.querySelector( 'option:checked' );

    if ( value ) elem.classList.remove( 'placeholder' );
    else elem.classList.add( 'placeholder' );

    const caption = 'Фільтрація данных табеля';
    const data = { id: this.dataId, field: paramName, field_id: value };
    const { colTd: { dataset: { pathFilter: url } } }  = this;
    MyLib.ajax( caption, url, 'post', data, 'script', null, true );
  }

  clickReasonAbsence( event ) {
    const { target: elem } = event;
    const { textContent: dataVal } = elem;
    const { dataset: { reasonsAbsenceId } } = elem;

    const cells = [ ];

    this.colTbTable.querySelectorAll( 'td.active' ).forEach( td => {
      const tdElem = td;
      if ( tdElem.dataset.reasonsAbsenceId !== reasonsAbsenceId ) {
        cells.push( tdElem.dataset.id );
        tdElem.textContent = dataVal;
        tdElem.dataset.reasonsAbsenceId = reasonsAbsenceId;
      }
      tdElem.classList.remove( 'active' );
    } );

    if ( cells.length ) {
      const caption = 'Группова заміна позначок табеля';
      const data = { ids: cells, reasons_absence_id: reasonsAbsenceId };
      const { colTd: { dataset: { pathUpdates: url } } } = this;
      MyLib.ajax( caption, url, 'post', data, 'json', null, true );
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

      this.colTbTable.querySelectorAll( '.active' )
        .forEach( cell => cell.classList.remove( classActive ) );

      this.colTbTable
        .querySelectorAll( `tbody tr:nth-child(n+${ this.rangeData.minRow }):nth-child(-n+${ this.rangeData.maxRow }) ` +
          `td:nth-child(n+${ this.rangeData.minCell }):nth-child(-n+${ this.rangeData.maxCell })` )
        .forEach( cell => {
          if ( cell.classList.contains( 'cell_mark' ) && !cell.hasAttribute( 'disabled' ) ) {
            cell.classList.add( classActive );
          }
        } );

      this.rangeData.prevRow = rowIndex;
      this.rangeData.prevCell = cellIndex;
    }
  }

  cellMarkClickLeft( target ) {
    const elem = target;

    if ( !this.disabled && !elem.hasAttribute( 'disabled' ) ) {
      const reasonsAbsence = this.colTd
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
      const reasonsAbsence = this.colTd.querySelector( 'button[data-reasons-absence-id]' );
      const { dataset: { reasonsAbsenceId } } = reasonsAbsence;
      elem.dataset.reasonsAbsenceId = reasonsAbsenceId;
      elem.textContent = '';
      this.markUpdate( elem.dataset.id, reasonsAbsenceId ); // обновление маркера
      this.calcMarks( );
    }
  }

  markUpdate( tbId, reasonsAbsenceId ) { // обновление маркера
    const data = { id: tbId, reasons_absence_id: reasonsAbsenceId };
    const caption = `Оновлення позначки табеля id = [ ${ tbId } ]`;
    const { colTd: { dataset: { pathUpdate: url } } }  = this;
    MyLib.ajax( caption, url, 'post', data, 'json', null, false );
  }

  cellMouseOver( event ) {
    event.preventDefault( );
    const { target: elem } = event;
    const { classList } = elem;
    elem.focus( );

    if ( !this.disabled ) this.changeMarkCell( event );

    const className = 'hover';
    if ( !elem.classList.contains( className ) && !classList.contains( 'name' ) ) {
      this.colTdParentTable.querySelectorAll( `.${ className }` ).forEach( hover => {
        const elemHover = hover;
        elemHover.classList.remove( className );
      } );

      this.colTdParentTable.querySelectorAll( `tr :nth-child( ${ elem.cellIndex + 1 } )` ).forEach( hover => {
        const elemHover = hover;
        elemHover.classList.add( className );
      } );
    }
  }

  cellMarkKeyDown( event ) {
    event.preventDefault( );
    if ( !this.disabled && !event.repeat && event.altKey ) {
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
    const { value: number } = this.parentElem.querySelector( '#number' );
    const { value: date } = this.parentElem.querySelector( '#date' );
    this.parentElem.querySelector( 'h1' ).textContent =
      `Табель № ${ number } від ${ date }`;
  }

  static clickRow( elem ) {
    const className = 'selected';

    Array.from( elem.parentElement.children ).forEach( child => {
      const { classList } = child;
      if ( child === elem ) classList.add( className ); else classList.remove( 'selected' );
    } );
  }

  clickHeader( target ) {
    const elem = target;
    elem.classList.toggle( 'hide' );
    this.parentElem.querySelector( '.panel_main' ).classList.toggle( 'hide' );
  }

  // подсчет итогов
  calcMarks( ) {
    this.colTbTable.querySelectorAll( '.cell_day' ).forEach( td => { // очистка все итогов
      const elem = td;
      elem.textContent = '';
      elem.dataset.absence = '';
    } );

    const cellSumName = [ 'appearance', 'absence' ];

    this.colTbTable.querySelectorAll( 'tr.row_data' ).forEach( tr => { // по всем строкам с данными
      const sum = [ 0, 0 ];

      const { dataset: { categoryId, groupId, childId } } = tr;

      tr.querySelectorAll( '.cell_mark:not([disabled]' ).forEach( td => {
        const elem = this.colTbTable.querySelector( `#group_${ categoryId }_${ groupId }_${ td.dataset.dateId }` );
        if ( td.textContent ) {
          sum[ 1 ] += 1;
          elem.dataset.absence = 1 + +elem.dataset.absence;
        } else {
          sum[ 0 ] += 1;
          elem.textContent = 1 + +elem.textContent;
        }
      } );

      cellSumName.forEach( ( val, i ) => {
        const sumElem = tr.querySelector( `#child_${ categoryId }_${ groupId }_${ childId }_${ val }` );
        sumElem.textContent = sum[ i ] || '';
      } );
    } );

    this.colTbTable.querySelectorAll( 'tr.group' ).forEach( tr => { // по всем строкам групп
      const sum = [ 0, 0 ];

      const { dataset: { categoryId, groupId } } = tr;

      tr.querySelectorAll( '.cell_day' ).forEach( ( td, index ) => {
        const elem = this.colTbTable.querySelector( `#category_${ categoryId }_${ index }` );
        const sumAppearance = +td.textContent;
        const sumAbsence = +td.dataset.absence;

        sum[ 0 ] += sumAppearance;
        sum[ 1 ] += sumAbsence;

        if ( sumAbsence ) elem.dataset.absence = sumAbsence + +elem.dataset.absence;
        if ( sumAppearance ) elem.textContent = sumAppearance + +elem.textContent;
      } );

      cellSumName.forEach( ( val, i ) => {
        const elemSum = tr.querySelector( `#group_${ categoryId }_${ groupId }_${ val }` );
        elemSum.textContent = sum[ i ] || '';
      } );
    } );

    this.colTbTable.querySelectorAll( 'tr.category' ).forEach( tr => { // по всем строкам с категорий
      const sum = [ 0, 0 ];

      const { dataset: { categoryId } } = tr;

      tr.querySelectorAll( '.cell_day' ).forEach( ( td, index ) => {
        const elem = this.colTbTable.querySelector( `#all_${ index }` );
        const sumAppearance = +td.textContent;
        const sumAbsence = +td.dataset.absence;

        sum[ 0 ] += sumAppearance;
        sum[ 1 ] += sumAbsence;

        if ( sumAbsence ) elem.dataset.absence = sumAbsence + +elem.dataset.absence;
        if ( sumAppearance ) elem.textContent = sumAppearance + +elem.textContent;
      } );

      cellSumName.forEach( ( val, i ) => {
        const elemSum = tr.querySelector( `#category_${ categoryId }_${ val }` );
        elemSum.textContent = sum[ i ] || '';
      } );
    } );

    this.colTbTable.querySelectorAll( 'tr.all' ).forEach( tr => { // по всем строкам итогов
      const sum = [ 0, 0 ];

      tr.querySelectorAll( '.cell_day' ).forEach( td => {
        sum[ 0 ] += +td.textContent;
        sum[ 1 ] += +td.dataset.absence;
      } );

      cellSumName.forEach( ( val, i ) => {
        const elemSum = tr.querySelector( `#all_${ val }` );
        elemSum.textContent = sum[ i ] || '';
      } );
    } );
  }
}
