/* exported MenuRequirementProducts */

class MenuRequirementProducts {
  // нажатие на кнопочку создать
  createProducts( ) {
    const data =  { id: this.dataId };
    const caption = `Формування страв та прийомів їжі id = [${ this.dataId }]`;
    const { colMd: { dataset: { pathCreate: url } } } = this;
    MyLib.ajax( caption, url, 'post', data, 'script', false, true );
  }

  mdUpdate( mdId, value ) { // обновление маркера
    const data = { id: mdId, is_enabled: value };
    const caption = `Онов. позн. страви та прийоми їжі id = [${ this.dataId }]`;
    const { colMd: { dataset: { pathUpdate: url } } } = this;
    MyLib.ajax( caption, url, 'post', data, 'json', false, false );
  }

  // шапка формы
  headerText( ) {
    const { value: number } = this.parentElem.querySelector( '#number' );
    const { value: date } = this.parentElem.querySelector( '#date' );
    this.parentElem.querySelector( 'h1' ).textContent =
      `Меню-вимога №  ${ number } від ${ date }`;
  }

  // нажатие на кнопочку выход
  clickExit( ) {
    MyLib.assignLocation( this.parentElem.dataset.pathExit );
  }

  clickSend( event ) {
    const pf = `pathSend${ MyLib.capitalize( event.currentTarget.dataset.pf ) }`;
    const caption = `Відправка данних в ІС [id: ${ this.dataId }]`;
    const data = { id: this.dataId };
    const successAjax = ( ) => window.location.reload( );
    const { parentElem: { dataset: { [ pf ]: url } } } = this;
    MyLib.ajax( caption, url, 'post', data, 'json', successAjax, true );
  }

  clickBtnPrint( ) {
    const caption = `Відправка данних в ІС [id: ${ this.dataId }]`;
    const data = { id: this.dataId };
    const { parentElem: { dataset: { pathPrint: url } } } = this;
    MyLib.ajax( caption, url, 'post', data, 'json', null, true );
  }

  clickMdCell( target ) {
    const elem = target;
    const dataId = +elem.dataset.id;
    const countPlan = +elem.dataset.countPlan;
    const isCheck = elem.classList.contains( 'check' );

    if ( ( !this.disabledPlan || !isCheck || !countPlan ) && !this.disabledFact && dataId ) {
      elem.classList.toggle( 'check' );
      this.mdUpdate( dataId, !isCheck );
      this.checkMdExists( );
    }
  }

  checkMdExists( ) {
    this.colMdCreate.disabled = this.disabledFact || !this.colMd.querySelector( 'td.check' );
  }

  contextmenuMdCell( event ) {
    event.preventDefault( );
    const { target: elem } = event;
    if ( !this.disabled ) this.mdUpdate( elem.dataset.id, false );
  }

  mouseoverMdCell( target ) {
    const elem = target;
    const className = 'hover';
    if ( !elem.classList.contains( className ) ) {
      this.colMd.querySelectorAll( `.${ className }` ).forEach( hover => {
        const elemHover = hover;
        elemHover.classList.remove( className );
      } );

      this.colMd.querySelectorAll( `thead tr:nth-child(2) :nth-child(${ elem.cellIndex }), ` +
          `tbody tr :nth-child(${ elem.cellIndex + 1 })` )
        .forEach( hover => {
          const elemHover = hover;
          elemHover.classList.add( className );
        } );
    }
  }

  clickNormCell( target ) {
    const elem = target;
    // const dataId = +elem.dataset.id;
    // const countPlan = +elem.dataset.countPlan;
    const isCheck = elem.classList.contains( 'check' );

    elem.classList.toggle( 'check' );
    // this.mdUpdate( dataId, !isCheck );
  }

  contextmenuNormCell( event ) {
    event.preventDefault( );
    const { target: elem } = event;
    // this.mdUpdate( elem.dataset.id, false );
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
    const { parentElement } = elem;
    elem.classList.toggle( 'hide' );
    const className = parentElement.id === this.parentElem.id ? '.panel_main' : '.panel';

    parentElement.querySelectorAll( className ).forEach( child => child.classList.toggle( 'hide' ) );
  }

  clickBtnMeals( target ) {
    const elem = target;
    const { dataset: { mealId } } = elem;

    elem.parentElement.querySelectorAll( 'button[data-meal-id]' ).forEach( child => {
      const elemChild = child;
      elemChild.disabled = elem === elemChild;
    } );

    if ( mealId === '-1' ) {
      this.colPrTable.querySelectorAll( '.hide[data-meal-id]' )
        .forEach( meal => {
          const elemMeal = meal;
          elemMeal.classList.remove( 'hide' );
        } );
    } else {
      this.colPrTable.querySelectorAll( '[data-meal-id]' )
        .forEach( meal => {
          const elemMeal = meal;
          if ( elemMeal.dataset.mealId === mealId ) elemMeal.classList.remove( 'hide' );
          else elemMeal.classList.add( 'hide' );
        } );
    }
  }

  clickBtnClmn( event ) {
    const { currentTarget: elem } = event;
    elem.parentElement.querySelectorAll( 'button[data-clmn].nav' ).forEach( child => {
      const elemChild = child;
      elemChild.disabled = elem === elemChild;
    } );

    const clmn = this.parentElem.querySelector( elem.dataset.clmn );
    clmn.parentElement.querySelectorAll( '.clmn' ).forEach( child => {
      const { classList } = child;
      if ( clmn === child ) classList.remove( 'hide' ); else classList.add( 'hide' );
    } );
  }

  constructor( elem ) {
    const self = this;
    const parentElem = elem;

    const disabledPlan = parentElem.dataset.disabledPlan === 'true';
    const disabledFact = parentElem.dataset.disabledFact === 'true';

    parentElem.querySelectorAll( 'input[data-date]' ).forEach( child => {
      const elemChild = child;
      elemChild.value = MyLib.toDateFormat( elemChild.dataset.date );
    } );

    const splendingdate = parentElem.querySelector( '#splendingdate' );
    ( { value: splendingdate.dataset.oldValue } = splendingdate );
    splendingdate.disabled = disabledPlan;
    $( splendingdate ).datepicker( { onSelect( ) { self.changeMenuRequirement( this ) } } );

    const btnExit = parentElem.querySelector( '.btn_exit' );
    btnExit.addEventListener( 'click', ( ) => this.clickExit( ) );

    if ( !disabledFact ) {
      btnExit.classList.remove( 'btn_exit' );
      btnExit.classList.add( 'btn_save' );
    }

    parentElem.querySelector( 'h1' ).addEventListener( 'click', event => this.clickHeader( event.currentTarget ) );

    parentElem.querySelectorAll( '.btn_send' ).forEach( child => {
      const elemChild = child;
      const { dataset: { pf } } = elemChild;
      elemChild.disabled = ( pf === 'plan' && disabledPlan ) ||
        ( pf === 'fact' && ( !disabledPlan || disabledFact ) );
      elemChild.addEventListener( 'click', event => this.clickSend( event ) );
    } );

    const btnPrint = parentElem.querySelector( '.btn_print' );

    if ( disabledPlan ) btnPrint.addEventListener( 'click', ( ) => this.clickBtnPrint( ) );
    else btnPrint.disabled = true;

    parentElem.querySelectorAll( '.panel_main button[data-clmn]' ).forEach( child => {
      child.addEventListener( 'click', event => this.clickBtnClmn( event ) );
      if ( child.matches( '[data-clmn="#col_pr"]' ) ) this.buttonColPr = child;
    } );

    const colCc = parentElem.querySelector( '#col_cc' );
    const colCcTable = colCc.querySelector( 'table' );

    colCcTable.addEventListener( 'change', event => {
      if ( event.target.matches( 'input' ) ) {
        this.changeCountCategoty( event.target );
        event.stopPropagation();
      }
    } );

    colCcTable.addEventListener( 'click', event => {
      const tr = event.target.closest( ' tr ' );
      if ( tr && tr.matches( '.row_data:not(.selected)' ) ) {
        this.constructor.clickRow( tr );
        event.stopPropagation();
      }
    } );

    const colMd = parentElem.querySelector( '#col_md' );
    colMd.querySelector( 'h2' ).addEventListener( 'click', event => this.clickHeader( event.currentTarget ) );

    const colMdCreate = colMd.querySelector( '.btn_create' );
    colMdCreate.addEventListener( 'click', ( ) => this.createProducts( ) );

    const colMdTable = colMd.querySelector( 'table' );

    if ( colMdTable ) {
      colMdTable.addEventListener( 'click', event => {
        if ( event.target.matches( 'td.cell_mark' ) ) {
          this.clickMdCell( event.target );
          event.stopPropagation();
        }
      } );

      colMdTable.addEventListener( 'contextmenu', event => {
        if ( event.target.matches( 'td.cell_mark' ) ) {
          this.contextmenuMdCell( event );
          event.stopPropagation();
        }
      } );

      colMdTable.addEventListener( 'mouseover', event => {
        if ( event.target.matches( 'td.cell_mark' ) ) {
          this.mouseoverMdCell( event.target );
          event.stopPropagation();
        }
      } );

      colMdTable.addEventListener( 'click', event => {
        const tr = event.target.closest( ' tr ' );
        if ( tr && tr.matches( '.row_data:not(.selected)' ) ) {
          this.constructor.clickRow( tr );
          event.stopPropagation();
        }
      } );

      $( colMdTable ).tableHeadFixer( );
    }

    const colPr = parentElem.querySelector( '#col_pr' );

    colPr.addEventListener( 'click', event => {
      if ( event.target.matches( 'h2' ) ) {
        this.clickHeader( event.target );
        event.stopPropagation();
      }

      if ( event.target.matches( 'button[data-pf]' ) ) {
        this.colPrTablePf( event.target.dataset.pf );
        event.stopPropagation();
      }

      if ( event.target.matches( 'button[data-meal-id]' ) ) {
        this.clickBtnMeals( event.target );
        event.stopPropagation();
      }

      const tr = event.target.closest( ' tr ' );
      if ( tr && tr.matches( '.row_data:not(.selected)' ) ) {
        this.constructor.clickRow( tr );
        event.stopPropagation();
      }
    } );

    colPr.addEventListener( 'change', event => {
      if ( event.target.matches( 'input' ) ) {
        this.changeCountProduct( event.target );
        event.stopPropagation( );
      }
    } );

    //-----------------------------------
    const colNorm = parentElem.querySelector( '#col_norm' );
    colMd.querySelector( 'h2' ).addEventListener( 'click', event => this.clickHeader( event.currentTarget ) );

    const colNormTable = colNorm.querySelector( 'table' );

    if ( colNormTable ) {
      colNormTable.addEventListener( 'click', event => {
        if ( event.target.matches( 'td.cell_mark' ) ) {
          this.clickNormCell( event.target );
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

      $( colMdTable ).tableHeadFixer( );
    }
    //-----------------------------------

    const menuItem = document.querySelector( '#main_menu li[data-page=menu_requirements]' );
    if ( menuItem ) {
      Array.from( menuItem.parentElement.children ).forEach( child => {
        const { classList } = child;
        if ( child === menuItem ) classList.add( 'active' ); else classList.remove( 'active' );
      } );
    }

    [ this.parentElem, this.colCc, this.colCcTable, this.colMd, this.colMdCreate, this.colMdTable, this.colPr ] =
      [ parentElem, colCc, colCcTable, colMd, colMdCreate, colMdTable, colPr ];

    [ this.dataId, this.disabledPlan, this.disabledFact ] =
      [ +parentElem.dataset.id, disabledPlan, disabledFact ];

    // parentElem.querySelector( '.panel_main button[data-clmn="#col_cc"]' ).click( );
    parentElem.querySelector( '.panel_main button[data-clmn="#col_norm"]' ).click( );
    this.headerText( );
    this.checkMdExists( );
    this.colCcInit( );
    this.colPrInit( null );
  }

  colPrInit( elements ) {
    if ( elements ) this.colPr.innerHTML = elements;

    this.colPrTable = this.colPr.querySelector( 'table' );

    if ( this.colPrTable ) {
      this.buttonColPr.classList.add( 'nav' );
      this.buttonColPr.disabled = false;

      $( this.colPrTable ).tableHeadFixer( { left: 2 } );

      this.colPrTable.querySelectorAll( 'td.price' ).forEach( child => {
        const elemChild = child;
        elemChild.textContent = MyLib.numToStr( +elemChild.textContent, -1 );
      } );

      const buttonMealAll = this.colPr.querySelector( 'button[data-meal-id="-1"]' );
      buttonMealAll.click( );

      this.colPrTablePf( this.disabledPlan ? 'fact' : 'plan' );

      this.categories = JSON.parse( this.colPrTable.dataset.categories || '[ ]' );

      this.calcProducts( );
    } else {
      this.buttonColPr.classList.remove( 'nav' );
      this.buttonColPr.disabled = true;
      this.calcCategories( );
    }
  }

  colPrTablePf( currentPf ) {
    this.colPrCurrentPf = currentPf;
    const currentDisabled = this.colPrCurrentPf === 'plan' ? this.disabledPlan : this.disabledFact;
    const dataCurrentPf = `count${ MyLib.capitalize( currentPf ) }`;
    const nameCurrentPf = `count_${ currentPf }`;

    if ( this.disabledPlan ) {
      const buttonPf = this.colPr.querySelector( `button[data-pf=${ currentPf }]` );
      this.colPr.querySelectorAll( 'button[data-pf]' ).forEach( child => {
        const elemChild = child;
        elemChild.disabled = child === buttonPf;
      } );
    } else {
      this.colPr.querySelectorAll( 'button[data-pf]' ).forEach( child => {
        const elemChild = child;
        if ( child.dataset.pf === 'plan' ) elemChild.classList.remove( 'nav' );
        elemChild.disabled = true;
      } );
    }

    this.colPrTable
      .querySelectorAll( '.cell_data input' )
      .forEach( child => {
        const elem = child;
        const { parentElement: { dataset: parentData } } = elem;
        const val = +parentData[ dataCurrentPf ];
        elem.dataset.oldValue = val;

        elem.disabled = currentDisabled || elem.dataset.id === '0';
        elem.name = nameCurrentPf;
        elem.value = MyLib.numToStr( val, -1 );
      } );

    this.calcCategories( );
  }

  calcProducts( ) {
    if ( this.colPrTable ) {
      const sumAll = this.categories.reduce( ( prev, cur ) => Object.assign( prev, { [ cur ]: { plan: 0, fact: 0 } } ), { } );
      const arrPlanFact = [ 'plan' ].concat( this.disabledPlan ? 'fact' : [] );

      this.colPrTable.querySelectorAll( 'tbody tr.row_data' ).forEach( tr => {
        const trElem = tr;
        const countProduct = { plan: 0, fact: 0 };
        const price = +trElem.querySelector( 'td.price' ).textContent;

        this.categories.forEach( categoryId => {
          const countCategory = { plan: 0, fact: 0 };

          trElem.querySelectorAll( `td.cell_data[data-children-category-id='${ categoryId }']` ).forEach( tdCell => {
            const tdCellElem  = tdCell;

            countCategory.plan += +tdCellElem.dataset.countPlan || 0;
            countCategory.fact += +tdCellElem.dataset.countFact || 0;
          } );

          arrPlanFact.forEach( pf => {
            const countCategoryPF = MyLib.toRound( countCategory[ pf ], 3 );
            const selectorCategory = `td[data-meal-id='0'][data-count-pf=${ pf }][data-children-category-id='${ categoryId }']`;

            countProduct[ pf ] += countCategoryPF;
            if ( price ) sumAll[ categoryId ][ pf ] += MyLib.toRound( price * countCategoryPF, 3 );

            trElem.querySelector( `${ selectorCategory }[data-count-type=count]` )
              .textContent = MyLib.numToStr( countCategoryPF, -1 );

            const diff = countCategory.fact - countCategory.plan;
            if ( pf === 'fact' && diff ) {
              trElem.querySelector( `${ selectorCategory }[data-count-type=diff]` )
                .textContent = MyLib.numToStr( MyLib.toRound( diff, 3 ), -1 );
            }
          } );
        } );

        arrPlanFact.forEach( pf => {
          const countProductPF = MyLib.toRound( countProduct[ pf ], 3 );
          const sumProduct = MyLib.toRound( price * countProductPF, 2 );

          trElem.querySelector( `td.cell_count[data-count-pf=${ pf }]` )
            .textContent = MyLib.numToStr( countProductPF, -1 );
          trElem.querySelector( `td.cell_sum[data-count-pf=${ pf }]` )
            .textContent = MyLib.numToStr( sumProduct, -1 );

          const diff = countProduct.fact - countProduct.plan;
          if ( pf === 'fact' && diff ) {
            trElem.querySelector( `td.cell_diff[data-count-pf=${ pf }]` )
              .textContent = MyLib.numToStr( MyLib.toRound( diff, 3 ), -1 );
          }
        } );
      } );

      this.categories.forEach( categoryId => {
        arrPlanFact.forEach( pf => {
          this.colCcTable.querySelector( `tr[data-id='${ categoryId }'] .sum_products_${ pf }` )
            .textContent = MyLib.numToStr( MyLib.toRound( sumAll[ categoryId ][ pf ], 2 ), -1 );
        } );
      } );
      this.calcCategories( );
    }
  }

  changeCountProduct( target ) {
    const elem = target;
    const { dataset } = elem;

    const valOld = +dataset.oldValue;
    const val = MyLib.toNumber( elem.value, 3 );
    const strVal = MyLib.numToStr( val, -1 );

    if ( val === valOld ) elem.value = strVal;
    else {
      const { name: nameVal } = elem;

      const successAjax = () => {
        elem.value = strVal;
        dataset.oldValue = val;
        elem.parentElement.dataset[ MyLib.camelize( nameVal ) ] = val;
        this.calcProducts( );
      };

      const { id: dataId } = dataset;
      const caption = `Зміна значення ${ nameVal } з ${ valOld } на ${ val } [id: ${ dataId }]`;
      const data = { id: dataId, [ nameVal ]: val };
      const { colPr: { dataset: { pathUpdate: url } } } = this;
      MyLib.ajax( caption, url, 'post', data, 'json', successAjax, false );
    }
  }

  changeMenuRequirement( target ) {
    const elem = target;
    const { id: nameVal, dataset: { oldValue: valOld }, value: val } = elem;
    if ( val !== valOld ) {
      elem.dataset.oldValue = val;
      const { dataId } = this;

      const data = { id: dataId, [ nameVal ]: val };
      const caption = `Зміна значення ${ nameVal } з ${ valOld } на ${ val } [id: ${ dataId }]`;
      const { parentElem: { dataset: { pathUpdate: url } } } = this;
      MyLib.ajax( caption, url, 'post', data, 'json', false, false );
    }
  }

  colCcInit( ) {
    this.colCcTable.querySelectorAll( 'td.day_cost' ).forEach( child => {
      const childElem = child;
      childElem.textContent = MyLib.numToStr( +childElem.textContent, -1 );
    } );

    this.colCcTable.querySelectorAll( 'input' ).forEach( child => {
      const elemChild = child;
      const val = +elemChild.value;
      elemChild.dataset.oldValue = val;

      elemChild.value = MyLib.numToStr( val, -1 );
      const { 0: pf } = elemChild.name.match( /[a-z]*$/ );

      elemChild.disabled = ( pf === 'plan' && this.disabledPlan ) ||
         ( pf === 'fact' && ( !this.disabledPlan || this.disabledFact ) );
    } );
  }

  changeCountCategoty( target ) {
    const elem = target;
    const { name: nameVal, dataset } = elem;

    const valOld = +dataset.oldValue;
    const val = MyLib.toNumber( elem.value, 0 );
    const strVal = MyLib.numToStr( val, -1 );

    if ( val === valOld ) elem.value = strVal;
    else {
      const successAjax = () => {
        elem.value = strVal;
        dataset.oldValue = val;
        this.calcCategories( );
      };

      const { id: dataId } = dataset;
      const captionAjax = `Зміна значення ${ nameVal } з ${ valOld } на ${ val } [id: ${ dataId }]`;
      const dataAjax = { id: dataId, [ nameVal ]: val };
      const { colCc: { dataset: { pathUpdate: url } } } = this;
      MyLib.ajax( captionAjax, url, 'post', dataAjax, 'json', successAjax, false );
    }
  }

  calcCategories() {
    const arrPlanFact = [ 'plan' ].concat( this.disabledPlan ? 'fact' : [] );

    const sumAll = arrPlanFact.reduce( ( prev, cur ) => Object.assign(
      prev, { [ cur ]: { countAll: 0, countExemption: 0, sumProducts: 0 } }
    ), { } );

    this.colCcTable.querySelectorAll( 'tbody tr.row_data' ).forEach( tr => {
      const trElem  = tr;
      const dayCost = +trElem.querySelector( '.day_cost' ).textContent;

      arrPlanFact.forEach( pf => {
        const countAll = +trElem.querySelector( `input[name=count_all_${ pf }]` ).value;
        const countExemption = +trElem.querySelector( `input[name=count_exemption_${ pf }]` ).value;
        const sumProducts = +trElem.querySelector( `.sum_products_${ pf }` ).textContent;
        const sumCost = MyLib.numToStr( countAll ? MyLib.toRound( sumProducts / countAll, 2 ) : 0, -1 );
        const diffCost = MyLib.toRound( sumCost - dayCost, 2 );

        trElem.querySelector( `.sum_cost_${ pf }` ).textContent = sumCost;
        trElem.querySelector( `.sum_diff_${ pf }` ).textContent = MyLib.numToStr( diffCost, -1 );

        if ( pf === this.colPrCurrentPf ) {
          const inputCategotySum = this.colPr.querySelector(
            `.panel input[data-children-category-id='${ trElem.dataset.id }']` );
          if ( inputCategotySum ) inputCategotySum.value = sumCost;
        }

        sumAll[ pf ].countAll += countAll;
        sumAll[ pf ].countExemption += countExemption;
        sumAll[ pf ].sumProducts += sumProducts;
      } );
    } );

    const trRowGroup = this.colCcTable.querySelector( 'tr.row_group' );
    arrPlanFact.forEach( pf => {
      trRowGroup.querySelector( `.count_all_${ pf }` ).textContent = MyLib.numToStr( sumAll[ pf ].countAll, -1 );
      trRowGroup.querySelector( `.count_exemption_${ pf }` ).textContent = MyLib.numToStr( sumAll[ pf ].countExemption, -1 );
      trRowGroup.querySelector( `.sum_products_${ pf }` ).textContent = MyLib.toRound( sumAll[ pf ].sumProducts, 2 );
    } );
  }
}
