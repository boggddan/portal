class MenuRequirementProducts {

  // Нажатие на кнопочку создать
  createProducts( ) {
    MyLib.ajax(
      this.captionMdCreate,
      this.urlMdCreate,
      'post',
      { id: this.dataId, bug: '' },
      'script' );
  }

  mdUpdate( mdId, value ) { // Обновление маркера
    const data = { id: mdId, is_enabled: value };
    MyLib.ajax( this.captionMdUpdate, this.urlMdUpdate, 'post', data, 'json', '', false, false );
  }

  // Шапка формы
  headerText( ) {
    this.h1.text( `Меню-вимога №  ${ $( '#number' ).val( ) } від ${ $( '#date' ).val( ) }` );
  }

  // Нажатие на кнопочку выход
  clickExit( ) {
    MyLib.pageLoader( true );
    window.location.replace( this.parentElem.data( 'path-exit' ) );
  }

  clickSend( event ) {
    const { currentTarget: { dataset: { pf } } } = event;

    MyLib.ajax(
      this.captionCcSend,
      this.parentElem.data( `path-send-${ pf }`),
      'post',
      { id: this.dataId, bug: '' },
      'json',
      false,
      ( ) => window.location.reload( ),
      true );
  }

  clickMdCell( event ) {
    const elem = $( event.currentTarget );
    if ( !this.disabledPlan ) {
      elem.toggleClass('check');
      this.mdUpdate( elem.data( 'id' ), elem.hasClass( 'check' ) );
      this.checkMdExists( );
    }
  }

  checkMdExists( ) {
    this.colMdCreate.attr( 'disabled', this.disabledFact || this.colMd.find( 'td.check' ).length === 0 );
  }

  contextmenuMdCell( event ) {
    event.preventDefault( );
    const elem = $( event.currentTarget );
    if ( !this.disabled ) this.mdUpdate( elem.data( 'id' ), false );
  }

  mouseoverMdCell( event ) {
    const elem = $( event.currentTarget );
    if ( !elem.hasClass( 'hover' ) ) {
      this.colMd
        .find('.hover').removeClass('hover')
        .end( )
        .find( `thead tr:nth-child(2) :nth-child( ${ elem.index() } ), tbody tr :nth-child( ${ elem.index() + 1 } )` )
        .addClass( 'hover' );
    }
  }

  mouseoverPrCell( event ) {
    const elem = $( event.currentTarget );
    if ( !elem.hasClass( 'hover' ) ) {
      this.colMd
        .find('.hover').removeClass('hover')
        .end( )
        .find( `thead tr:nth-child(2) :nth-child( ${ elem.index() } ), tbody tr :nth-child( ${ elem.index() + 1 } )` )
        .addClass( 'hover' );
    }
  }

  static clickRow( event ) {
    $( event.currentTarget ).addClass(' selected ').siblings( ).removeClass( 'selected' );
  }

  clickHeader( event ) {
    const elem = $( event.currentTarget );
    elem.toggleClass( 'hide' );
    const parent = elem.parent();
    const className = parent.attr( 'id' ) === this.parentElem.attr('id') ? '.panel_main' : '.panel';

    parent.find( className ).toggleClass( 'hide' );
  }

  clickBtnMeals( event ) {
    const elem = $( event.currentTarget );
    const mealId = elem.data( 'meal-id' );
    elem.prop( 'disabled', true ).siblings( 'button[data-meal-id]' ).prop( 'disabled', false );
    if ( mealId === -1 ) {
      this.colPrTable.find( '.hide' ).removeClass( 'hide' );
    } else {
      this.colPrTable
        .find( `[data-meal-id]:not([data-meal-id=${ mealId }])` ).addClass( 'hide' )
        .end( )
        .find( `[data-meal-id=${ mealId }]` ).removeClass( 'hide' );
    }
  }

  clickBtnClmn( event ) {
    const elem = $( event.currentTarget );
    elem.attr( 'disabled', true ).siblings( ).attr( 'disabled', null );
    this.parentElem.find( elem.data( 'clmn' ) ).removeClass('hide').siblings().addClass( 'hide' );
  }

  constructor( parentElem ) {
    const self = this;

    this.parentElem = parentElem;
    this.dataId = parentElem.data( 'id' );
    this.disabledPlan = parentElem.data( 'disabled-plan' );
    this.disabledFact = parentElem.data( 'disabled-fact' );
    this.h1 = parentElem.find( 'h1' );
    this.h1.on( 'click', event => this.clickHeader( event ) );

    this.urlUpdate = this.parentElem.data( 'path-update' );

    const splendingdate = parentElem.find( '#splendingdate' );
    splendingdate
      .val( splendingdate.val( ) )
      .prop( 'disabled', this.disabledPlan )
      .datepicker( { onSelect( ) { self.changeMenuRequirement(this) } } );

    splendingdate.get( 0 ).dataset.oldValue = splendingdate.val( );

    this.btnExit = parentElem.find( '.btn_exit' )
      .on( 'click', event => MyLib.btnExitClick( $( event.currentTarget ) ) );
    if (!this.disabledFact) this.btnExit.removeClass( 'btn_exit' ).addClass( 'btn_save' );

    this.buttonColPr = parentElem.find( '.panel_main button[data-clmn="#col_pr"] ');

    parentElem
      .find( '.btn_send' )
      .on( 'click', event => this.clickSend( event) )
      .end( )
      .find( '.btn_send[data-pf=plan]' ).prop( 'disabled', this.disabledPlan )
      .end( )
      .find( '.btn_send[data-pf=fact]' ).prop( 'disabled', !this.disabledPlan || this.disabledFact )
      .end( )
      .find( '.panel_main button[data-clmn]' )
      .on( 'click', event => this.clickBtnClmn( event ) )
      .end( )
      .find( '.btn_exit' )
      .on('click', ( ) => this.clickExit( ) )
      .end( )
      .find( '.panel_main button[data-clmn="#col_cc"] ').click( );

    this.colCc = parentElem.find('#col_cc');
    this.captionCcSend = `Відправка данних в 1С [id: ${ this.dataId }]`;
    this.urlCcUpdate = this.colCc.data( 'path-update' );

    this.colCcTable = this.colCc.find('table');
    this.colCcTable
      .tableHeadFixer( )
      .on( 'change', 'input', event => this.changeCountCategoty( event ) )
      .on( 'click', 'tr.row_data:not(.selected)', event => this.constructor.clickRow( event ) );

    this.colMd = parentElem.find('#col_md');
    this.captionMdUpdate = `Онов. позн. страви та прийоми їжі id = [${ this.dataId }]`;
    this.captionMdCreate = `Формування страв та прийомів їжі id = [${ this.dataId }]`;

    this.urlMdUpdate = this.colMd.data( 'path-update' );
    this.urlMdCreate = this.colMd.data( 'path-create' );

    this.colMdCreate = this.colMd.find( '.btn_create' ).on( 'click', ( ) => this.createProducts( ) );
    this.colMd.find( 'h2' ).on( 'click', event => this.clickHeader( event ) );

    this.colMdTable = this.colMd.find( 'table' );

    this.colMdTable
      .tableHeadFixer( )
      .on( 'click', 'td.cell_mark', event => this.clickMdCell( event ) )
      .on( 'contextmenu', 'td.cell_mark', event => this.contextmenuMdCell( event ) )
      .on( 'mouseover', 'td.cell_mark', event => this.mouseoverMdCell( event ) )
      .on( 'click', 'tr.row_data:not(.selected)', event => this.constructor.clickRow( event ) );

    this.colPr = parentElem.find('#col_pr');

    this.urlPrUpdate = this.colPr.data( 'path-update' );

    this.colPr
      .on( 'click', 'h2', event => this.clickHeader( event ) )
      .on( 'click', 'button[data-pf]', event => this.colPrTablePf( event.currentTarget.dataset.pf ) )
      .on( 'click', 'button[data-meal-id]', event => this.clickBtnMeals( event ) )
      .on( 'change', 'td.cell_data input', event => this.changeCountProduct( event ) )
      .on( 'click', 'tr.row_data:not(.selected)', event => this.constructor.clickRow( event ) );

    this.headerText( );
    $( '#main_menu li[data-page=menu_requirements]' ).addClass( 'active' ).siblings( ).removeClass( 'active' );

    this.checkMdExists( );
    this.colCcInit( );
    this.colPrInit( );
  }

  colPrInit( ) {
    this.colPr.find( 'button[data-meal-id=-1]' ).prop( 'disabled', true );

    this.colPrTable = this.colPr.find( 'table' );

    this.colPrTable
      .tableHeadFixer( { left: 2 } )
      .find( '.price' )
      .each( (...dataEach ) => {
        const { 1: elem } = dataEach;
        elem.innerHTML = MyLib.numToStr( +elem.innerHTML, -1);
      } );

    this.colPrTablePf( this.disabledPlan ? 'fact' : 'plan' );
    this.calcProducts( );
  }

  colPrTablePf( currentPf ) {
    this.colPrCurrentPf = currentPf;
    const currentDisabled = this.colPrCurrentPf === 'plan' ? this.disabledPlan : this.disabledFact;
    const dataCurrentPf = `count${ MyLib.capitalize( currentPf ) }`;
    const nameCurrentPf = `count_${ currentPf }`;

    if ( !this.disabledPlan ) this.colPr.find( 'button[data-pf]' ).prop( 'disabled', true );
    else {
      this.colPr
        .find( `button[data-pf=${ currentPf }]` ).prop( 'disabled', true )
        .siblings( 'button[data-pf]' ).prop( 'disabled', false );
    }

    this.colPrTable
      .find( '.cell_data input' )
      .each( ( ...dataEach ) => {
        const { 1: elem } = dataEach;
        const val = +elem.parentElement.dataset[ dataCurrentPf ];
        elem.dataset.oldValue = val;

        elem.disabled = currentDisabled;

        elem.setAttribute( 'name', nameCurrentPf );
        elem.value = MyLib.numToStr( val, -1);
      } );

    this.calcCategories( );
  }

  calcProducts( ) {
    const categories = this.colPrTable.data( 'categories' ) || [ ];

    const sumAll = categories.reduce( ( p, c ) => Object.assign( p, { [ c ]: { plan: 0, fact: 0 } } ), { } );
    const arrPlanFact = [ 'plan' ].concat( this.disabledPlan ? 'fact' : [] );

    this.colPrTable.find( 'tbody tr.row_data' ).each( ( ...tr ) => {
      const trElem = $( tr[ 1 ] );
      const countProduct = { plan: 0, fact: 0 };
      const price = +trElem.children( 'td.price' ).text( );

      categories.forEach( categoryId => {
        const countCategory = { plan: 0, fact: 0 };

        trElem.children( `td.cell_data[data-children-category-id=${ categoryId }]` ).each( ( ...tdCell ) => {
          const tdCellElem  = $( tdCell[ 1 ] );

          countCategory.plan += +tdCellElem.data( 'count-plan' ) || 0;
          countCategory.fact += +tdCellElem.data( 'count-fact' ) || 0;
        } );

        arrPlanFact.forEach( pf => {
          const countCategoryPF = MyLib.toRound( countCategory[ pf ], 3 );
          const selectorCategory = `td[data-meal-id=0][data-count-pf=${ pf }][data-children-category-id=${ categoryId }]`;

          countProduct[ pf ] += countCategoryPF;
          if ( price ) sumAll[ categoryId ][ pf ] += MyLib.toRound( price * countCategoryPF, 3);

          trElem.children( `${ selectorCategory }[data-count-type=count]` )
            .text( MyLib.numToStr( countCategoryPF, -1 ) );

          const diff = countCategory.fact - countCategory.plan;
          if ( pf === 'fact' && diff ) {
            trElem.children( `${ selectorCategory }[data-count-type=diff]` )
              .text( MyLib.numToStr( MyLib.toRound( diff, 3 ), -1 ) );
          }
        } );
      } );

      arrPlanFact.forEach( pf => {
        const countProductPF = MyLib.toRound( countProduct[ pf ], 3 );
        const sumProduct = MyLib.toRound( price * countProductPF, 2 );

        trElem.children( `td.cell_count[data-count-pf=${ pf }]` ).text( MyLib.numToStr( countProductPF, -1 ) );
        trElem.children( `td.cell_sum[data-count-pf=${ pf }]` ).text( MyLib.numToStr( sumProduct, -1 ) );

        const diff = countProduct.fact - countProduct.plan;
        if ( pf === 'fact' && diff ) {
          trElem.children( `td.cell_diff[data-count-pf=${ pf }]` )
            .text( MyLib.numToStr( MyLib.toRound( diff, 3 ), -1 ) );
        }
      } );

    } );

    categories.forEach( categoryId => {
      arrPlanFact.forEach( pf => {
        $( `tr[data-id='${ categoryId }'] .sum_products_${ pf }` )
          .text( MyLib.numToStr( MyLib.toRound( sumAll[ categoryId ][ pf ], 2 ), -1 ) );
      } );
    } );
    this.calcCategories ( );
  }

  changeCountProduct( event ) {
    const elem = $( event.currentTarget );

    const valOld =  +elem.data( 'old-value' );
    const val = MyLib.toNumber( elem.val( ), 3 );
    const strVal = MyLib.numToStr( val, -1 );

    if ( val !== valOld ) {
      const nameVal = elem.attr( 'name' );

      const successAjax = () => {
        elem.val( strVal ).attr( 'value', strVal ).data( 'old-value', val );
        elem.parent().data( nameVal.replace( '_', '-' ), val );
        this.calcProducts( );
      };

      const dataId = elem.data( 'id' );
      const captionAjax = `Зміна значення ${ nameVal } з ${ valOld } на ${ val } [id: ${ dataId }]`;
      const dataAjax = { id: dataId, [nameVal]: val };

      MyLib.ajax( captionAjax, this.urlPrUpdate, 'post', dataAjax,'json', '', successAjax, false );
    } else {
      elem.val( strVal ).attr( 'value', strVal );
    }
  }

  changeMenuRequirement( target ) {
    const elem = target;
    const { id: nameVal, dataset: { oldValue: valOld }, value: val } = elem;

    if ( val !== valOld ) {
      elem.dataset.oldValue = val;
      const { dataId } = this;

      const captionAjax = `Зміна значення ${ nameVal } з ${ valOld } на ${ val } [id: ${ dataId }]`;
      const dataAjax = { id: dataId, [nameVal]: val };

      MyLib.ajax( captionAjax, this.urlUpdate, 'post', dataAjax,'json', '', false, false );
    }
  }

  colCcInit( ) {
    this.colCcTable
      .find( '.day_cost' )
      .each( (...dataEach ) => {
        const { 1: elem } = dataEach;
        elem.innerHTML = MyLib.numToStr( +elem.innerHTML, -1);
      } )
      .end( )
      .find( 'input' )
      .each( (...dataEach ) => {
        const { 1: elem } = dataEach;
        const val = +elem.value;
        elem.dataset.oldValue = val;

        elem.value = MyLib.numToStr( val, -1 );
        const { 0: pf } = elem.name.match( /[a-z]*$/ );

        if ( pf === 'plan' && this.disabledPlan || ( pf === 'fact' && !this.disabledPlan || this.disabledFact ) ) {
          elem.disabled = true;
        }
      } );
  }

  changeCountCategoty( event ) {
    const elem = $( event.currentTarget );

    const valOld =  +elem.data( 'old-value' );
    const val = MyLib.toNumber( elem.val( ), 0 );
    const strVal = MyLib.numToStr( val, -1 );

    if ( val !== valOld ) {
      const successAjax = () => {
        elem.val( strVal ).attr( 'value', strVal ).data( 'old-value', val );
        this.calcCategories( );
      };

      const dataId = elem.data( 'id' );
      const nameVal = elem.attr( 'name' );
      const captionAjax = `Зміна значення ${ nameVal } з ${ valOld } на ${ val } [id: ${ dataId }]`;
      const dataAjax = { id: dataId, [nameVal]: val };

      MyLib.ajax( captionAjax, this.urlCcUpdate, 'post', dataAjax,'json', '', successAjax, false );
    } else {
      elem.val( strVal ).attr( 'value', strVal );
    }
  }

  calcCategories () {
    const arrPlanFact = [ 'plan' ].concat( this.disabledPlan ? 'fact' : [] );

    const sumAll = arrPlanFact.reduce( (p, c) => Object.assign(
      p, { [c]: { count_all: 0, count_exemption: 0, sum_products: 0 } }
    ), { } );

    this.colCcTable.find( 'tbody tr.row_data' ).each( ( ...tr ) => {
      const trElem  = $( tr[ 1 ] );
      const dayCost = +trElem.find( '.day_cost' ).text( );

      arrPlanFact.forEach( pf => {
        const countAll = +trElem.find( `input[name=count_all_${ pf }]` ).val( );
        const countExemption = +trElem.find( `input[name=count_exemption_${ pf }]` ).val( );
        const sumProducts = +trElem.find( `.sum_products_${ pf }` ).text( );
        const sumCost = MyLib.numToStr( countAll ? MyLib.toRound( sumProducts / countAll, 2) : 0, -1 );
        const diffCost = MyLib.toRound( sumCost - dayCost, 2 );

        trElem.children( `.sum_cost_${ pf }` ).text( sumCost );
        trElem.children( `.sum_diff_${ pf }` ).text( MyLib.numToStr( diffCost, -1) );

        if ( pf === this.colPrCurrentPf ) {
          this.colPr.find( `.panel input[data-children-category-id='${ trElem.data( 'id' ) }']` )
            .val( sumCost );
        }

        sumAll[ pf ].count_all += countAll;
        sumAll[ pf ].count_exemption += countExemption;
        sumAll[ pf ].sum_products += sumProducts;
      } );
    } );

    const trRowGroup = this.colCcTable.find( 'tr.row_group' );
    arrPlanFact.forEach( pf => {
      trRowGroup.children( `.count_all_${ pf }` ).text( MyLib.numToStr( sumAll[ pf ].count_all, -1 ) );
      trRowGroup.children( `.count_exemption_${ pf }` ).text( MyLib.numToStr( sumAll[ pf ].count_exemption, -1 ) );
      trRowGroup.children( `.sum_products_${ pf }` ).text( MyLib.numToStr( sumAll[ pf ].sum_products, -1 ) );
    } );
  }
}
