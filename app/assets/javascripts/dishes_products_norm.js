/* exported DishesProductsNorms */

class DishesProductsNorms {
  constructor( elem ) {
    const parentElem = elem;

    const colNorm = parentElem.querySelector( '#col_norm' );
    const colNormTable = colNorm.querySelector( 'table' );

    if ( colNormTable ) {
      colNormTable.addEventListener( 'click', event => {
        if ( event.target.matches( 'tr.row_group td.cell_mark' ) ) {
          // this.clickNormGroup( event.target );
          event.stopPropagation();
        }

        if ( event.target.matches( 'tr.row_data td.cell_mark:not( [ data-institution = "0" ] )' ) ) {
          // this.clickNormCell( event.target );
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

  clickNormGroup( target ) {
    const elem = target;
    const { parentNode: parent } = elem;
    const { dataset: parentDataset } = parent;

    const dataForCss = Object.keys( parentDataset ).reduce( ( acc, cur ) =>
      `${ acc }[data-${ MyLib.kebab( cur ) }="${ parentDataset[ cur ] }"]`, '' );

    const className = 'check';
    elem.classList.toggle( className );
    const isCheck = elem.classList.contains( className );

    const dishesProducts = [ ];
    const existsClass = isCheck ? `:not(.${ className })` : `.${ className }`;

    this.colNormTable.querySelectorAll( `tr.row_data${ dataForCss } td.cell_mark${ existsClass }` )
      .forEach(
        child => {
          const childElem = child;
          const { dataset: childDataset } = childElem;

          childElem.classList.toggle( className );

          dishesProducts.push( {
            id: +childDataset.id,
            dish_id: +childDataset.dishId,
            product_id: +childDataset.productId
          } );
        }
      );

    this.sendNormtoServer( dishesProducts, isCheck );
  }

  sendNormtoServer( dishesProducts, isCheck ) {
    const caption = 'Вибір відображення продукту в стравах';
    const { colNorm: { dataset: { pathUpdate: url } } } = this;
    const preloaderVisible = dishesProducts.length > 10;
    const data = { dishes_products: dishesProducts, enabled: isCheck };

    MyLib.ajax( caption, url, 'post', data, 'json', null, preloaderVisible );
  }

  clickNormCell( target ) {
    const elem = target;
    const { dataset: elemDataset } = elem;
    const dishId = +elemDataset.dishId;

    const className = 'check';
    elem.classList.toggle( className );
    const isCheck = elem.classList.contains( className );

    const dishesProducts = [
      {
        id: +elemDataset.id,
        dish_id: dishId,
        product_id: +elemDataset.productId
      }
    ];

    this.sendNormtoServer( dishesProducts, isCheck );
    this.checkDishChoose( dishId );
  }

  checkDishChoose( dishId ) {
    const className = 'check';
    const elems = this.colNormTable.querySelectorAll(
      `tr.row_data[ data-dish-id = "${ dishId }" ] td.cell_mark:not(.${ className })` );

    const { classList: elemDishClassList } = this.colNormTable.querySelector(
      `tr.row_group.dish[ data-dish-id = "${ dishId }" ] td.cell_mark` );

    if ( elems.length ) elemDishClassList.remove( className ); else elemDishClassList.add( className );
  }

  colNormInit( ) {
    this.colNormTable.querySelectorAll( 'tr.row_group.dish' )
      .forEach( child => this.checkDishChoose( child.dataset.dishId ) );

    this.colNormTable.querySelectorAll( 'td.amount' )
      .forEach( child => {
        const childElem = child;
        console.log('dfdf')
        childElem.textContent = MyLib.numToStr( +childElem.textContent, -1 );
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
