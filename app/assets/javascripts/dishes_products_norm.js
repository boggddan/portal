/* exported DishesProductsNorms */

class DishesProductsNorms {
  constructor( elem ) {
    const parentElem = elem;

    const colNorm = parentElem.querySelector( '#col_norm' );
    const colNormTable = colNorm.querySelector( 'table' );

    if ( colNormTable ) {
      colNormTable.addEventListener( 'click', event => {
        if ( event.target.matches( 'tr.row_group.dish:not( [ data-institution = "0" ] ) td.cell_mark' ) ) {
          this.clickDishCell( event.target );
          event.stopPropagation();
        }
      } );

      colNormTable.addEventListener( 'click', event => {
        const tr = event.target.closest( ' tr ' );
        if ( tr && tr.matches( '.row_data:not(.selected)' ) ) {
          this.constructor.clickRow( tr );
          event.stopPropagation();
        }
      } );

      $( colNormTable ).tableHeadFixer( );
    }
    //-----------------------------------

    [ this.parentElem, this.colNorm, this.colNormTable ] = [ parentElem, colNorm, colNormTable ];

    this.colNormInit( );
  }

  clickDishCell( target ) {
    const elem = target;
    const { dataset: elemDataset } = elem;
    const institutionDishId = +elemDataset.institutionDishId;

    const className = 'check';
    elem.classList.toggle( className );
    const isCheck = elem.classList.contains( className );

    const caption = 'Вибір відображення продукту в стравах';
    const { colNorm: { dataset: { pathUpdate: url } } } = this;
    const data = { institution_dish_id: institutionDishId, enabled: isCheck };

    MyLib.ajax( caption, url, 'post', data, 'json', null, false );
  }

  colNormInit( ) {
    this.colNormTable.querySelectorAll( 'td.amount' )
      .forEach( child => {
        const childElem = child;
        const { textContent: value } = childElem;
        if ( value !== '-' ) childElem.textContent = MyLib.numToStr( +value, -1 );
      } );
  }

  static clickRow( elem ) {
    const className = 'selected';

    Array.from( elem.parentElement.children ).forEach( child => {
      const { classList } = child;
      if ( child === elem ) classList.add( className ); else classList.remove( 'selected' );
    } );
  }
}
