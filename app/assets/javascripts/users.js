/* exported Users */

class Users extends FormList {
  constructor( elem ) {
    super( elem );
    this.parentElem = elem;

    const colUs = this.parentElem.querySelector( '#col_us' );
    const colUsParentTable = colUs.querySelector( '.parent_table' );

    this.tableEvents( colUs );
    MyLib.mainMenuActive( 'users' );

    [ this.colUs, this.colUsParentTable ] = [ colUs, colUsParentTable ];

    this.getTableColUs( );
  }

  filterTableColUs( ) { // фильтрация таблицы документов
    MyLib.setClearTableSession( this.parentElem.id, this.colUs.id );
    this.getTableColUs( );
  }

  getTableColUs( ) {
    const clmnObj = MyLib.getSession( this.parentElem.id )[ this.colUs.id ] || { };
    const caption = 'Фільтрація користвувачів';
    const { colUs: { dataset: { pathFilter: url } } } = this;
    const data = { sort_field: clmnObj.sortField || '', sort_order: clmnObj.sortOrder || '' };
    MyLib.ajax( caption, url, 'post', data, 'script', null, true );
  }

  colUsInit( elements ) {
    this.colUsParentTable.innerHTML = elements;
    this.tableSetSession( this.colUsParentTable );
    this.tableFormat( this.colUsParentTable );
  }
}

