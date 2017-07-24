/* exported FormList */

class FormList {
  constructor( elem ) {
    this.parentElem = elem;

    this.parentElem.querySelectorAll( '.btn_create' ).forEach( child => {
      child.addEventListener( 'click', event => this.createClick( event ) );
    } );
  }

  tableEvents( elem ) {
    const { parentElem: { id: sessionKey } } = this;
    const { id: clmnKey } =  elem;
    const headerClick =  `getTable${ MyLib.capitalize( MyLib.camelize( clmnKey ) ) }`;
    const parentTable = elem.querySelector( '.parent_table' );

    parentTable.addEventListener( 'click', event => {
      if ( event.target.matches( '.btn_edit' ) ) {
        this.tableEditClick( event.target );
        event.stopPropagation();
      }

      if ( event.target.matches( '.btn_del' ) ) {
        this.tableDelClick( event.target, null );
        event.stopPropagation();
      }

      if ( event.target.matches( 'th[data-sort]' ) ) {
        this.tableHeaderClick( event.target, this[ headerClick ].bind( this ) );
        event.stopPropagation();
      }

      const tr = event.target.closest( 'tr' );
      if ( tr && tr.matches( '.row_data:not(.selected)' ) ) {
        this.rowClick( tr, null );
        event.stopPropagation();
      }
    } );

    parentTable.addEventListener( 'scroll', event => {
      MyLib.setSession( sessionKey, { [ clmnKey ]: { scrollTop: event.target.scrollTop } } );
    } );
  }

  // нажатие на строку в табичке
  rowClick( elem, callBack ) {
    const className = 'selected';
    const { parentElem: { id: sessionKey } } = this;
    const { id: clmnKey } = elem.closest( '.clmn' );
    MyLib.setSession( sessionKey, { [ clmnKey ]: { rowId: elem.dataset.id } } );

    Array.from( elem.parentElement.children ).forEach( child => {
      if ( child === elem ) child.classList.add( className ); else child.classList.remove( className );
    } );

    if ( callBack ) callBack( );
  }

  tableEditClick( elem ) {
    const { dataset: { pathView: url } } = elem.closest( '.clmn' );
    const { dataset: { id } } = elem.closest( 'tr' );

    MyLib.assignLocation( url, { id } ); // для перехода в табличную часть
  }

  tableDelClick( elem, callBack ) {
    const { parentElem: { id: key } } = this;
    const table = elem.closest( 'table' );
    const tr = elem.closest( 'tr' );

    const { id: clmnKey, dataset: { pathDel: url, caption: captionClmn } } = elem.closest( '.clmn' );
    const { dataset: { id } } = tr;

    const { textContent: dataDel } = tr.querySelector( 'td[data-delete]' );
    const caption = `Видалення: ${ captionClmn } ${ dataDel } `;

    const successAjax = ( ) => {
      if ( table.querySelectorAll( 'tbody tr' ).length === 1 ) table.remove( ); else tr.remove( );
      MyLib.setClearTableSession( key, clmnKey );
      if ( callBack ) callBack( );
    };

    const callbackOk = ( ) => MyLib.ajax( caption, url, 'delete', { id }, 'json', successAjax, true );
    MyLib.delMsg( caption, callbackOk );
  }

  // нажатие для сортировки
  tableHeaderClick( elem, callBack ) {
    const { parentElem: { id: key } } = this;
    const { classList, dataset } = elem;
    const classOrder = { add: 'desc', remove: 'asc' };
    const { id: clmnKey } = elem.closest( '.clmn' );

    if ( classList.contains( classOrder.add ) ) [ classOrder.add, classOrder.remove ] = [ classOrder.remove, classOrder.add ];
    classList.remove( classOrder.remove );
    classList.add( classOrder.add );
    const value = { [ clmnKey ]: { sortField: dataset.sort, sortOrder: classOrder.add } };

    MyLib.setSession( key, value );
    if ( callBack ) callBack( ); // фильтрация таблицы документов
  }

  tableSetSession( parentTable ) {
    const elem = parentTable;
    const { parentElem: { id: sessionKey } } = this;
    const { id: clmnKey } = elem.closest( '.clmn' );

    const table = elem.querySelector( 'table' );
    $( table ).tableHeadFixer( ); // фиксируем шапку таблицы

    const { [ clmnKey ]: clmnObj } = MyLib.getSession( sessionKey );

    if ( clmnObj ) {
      const { sortField, sortOrder, scrollTop, rowId } = clmnObj;
      if ( sortField ) table.querySelector( `th[data-sort='${ sortField }']` ).classList.add( sortOrder );

      if ( scrollTop ) elem.scrollTop = scrollTop;

      if ( rowId ) {
        const tr = table.querySelector( `tr[data-id='${ rowId }']` );
        if ( tr ) tr.classList.add( 'selected' );
        else MyLib.setSession( sessionKey, { [ clmnKey ]: { rowId: 0 } } );
      }
    }
  }

  tableFormat( elem ) {
    elem.querySelectorAll( 'td[data-date]' ).forEach( child => {
      const elemChild = child;
      elemChild.textContent = MyLib.toDateFormat( elemChild.dataset.date );
    } );
  }

  createClick( { target: elem } ) {
    MyLib.assignLocation( elem.closest( '.clmn' ).dataset.pathCreate );
  }
}

