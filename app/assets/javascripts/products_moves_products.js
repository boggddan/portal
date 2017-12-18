/* exported ProductsMoveProducts */
/* global objFormSplash */

class ProductsMoveProducts {
  constructor( elem ) {
    const self = this;
    const parentElem = elem;

    this.isDateBlocks = parentElem.dataset.isDateBlocks === 'true';
    this.isConfirmed = parentElem.dataset.isConfirmed === 'true';
    this.isSendFirst = parentElem.dataset.isSendFirst === 'true';
    this.isPost = parentElem.dataset.isPost === 'true';
    this.isEdit = parentElem.dataset.isEdit === 'true';

    ( { textContent: this.user } = document.querySelector( '#main_menu li.info span:first-child' ) );

    parentElem.querySelectorAll( 'input[data-date]' ).forEach( child => {
      const elemChild = child;
      elemChild.value = MyLib.toDateFormat( elemChild.dataset.date );
    } );

    const date = parentElem.querySelector( '#date' );
    ( { value: date.dataset.oldValue } = date );
    $( date ).datepicker( { onSelect( ) { self.changeProductsMove( this ) } } );
    date.disabled = this.isDateBlocks || !this.isSendFirst || !this.isPost;

    const toInstitutionId = parentElem.querySelector( '#to_institution_id' );
    toInstitutionId.addEventListener( 'change', event => this.changeProductsMove( event.currentTarget ) );
    toInstitutionId.disabled = this.isDateBlocks || !this.isSendFirst || !this.isPost;

    const btnExit = parentElem.querySelector( '.btn_exit' );
    btnExit.addEventListener( 'click', ( ) => this.clickExit( ) );
    if ( !this.isDateBlocks && this.isPost && this.isEdit ) {
      btnExit.classList.remove( 'btn_exit' );
      btnExit.classList.add( 'btn_save' );
    }

    parentElem.querySelector( 'h1' ).addEventListener( 'click', event => this.clickHeader( event.currentTarget ) );

    const btnSend = parentElem.querySelector( '.btn_send' );
    btnSend.addEventListener( 'click', event => this.clickSend( event ) );
    btnSend.disabled = this.isDateBlocks || !this.isPost || !this.isEdit;

    const btnConfirmed = parentElem.querySelector( '.btn_confirmed' );
    btnConfirmed.addEventListener( 'click', ( ) => this.clickConfirmed( ) );
    btnConfirmed.disabled = this.isDateBlocks || this.isEdit || this.isConfirmed || this.isPost;

    const btnEdit = parentElem.querySelector( '.btn_edit' );
    btnEdit.addEventListener( 'click', ( ) => this.clickEdit( ) );
    btnEdit.disabled = this.isDateBlocks || this.isEdit || !this.isPost;

    const btnPrices = parentElem.querySelector( '.btn_prices' );
    btnPrices.addEventListener( 'click', ( ) => this.clickBtnPrices( ) );
    btnPrices.disabled = this.isDateBlocks || !this.isPost || !this.isEdit;

    const clmn = parentElem.querySelector( '.clmn' );
    const table = clmn.querySelector( 'table' );

    table.addEventListener( 'change', event => {
      if ( event.target.matches( 'input' ) ) {
        this.changeCountProduct( event.target );
        event.stopPropagation();
      }
    } );

    table.addEventListener( 'click', event => {
      const tr = event.target.closest( ' tr ' );
      if ( tr && tr.matches( '.row_data:not(.selected)' ) ) {
        this.constructor.clickRow( tr );
        event.stopPropagation();
      }
    } );

    MyLib.mainMenuActive( 'products_move' );

    [ this.parentElem, this.clmn, this.table ] = [ parentElem, clmn, table ];
    [ this.dataId ] = [ +parentElem.dataset.id ];

    this.headerText( );
    this.clmnInit();
  }

  changeProductsMove( target ) {
    const elem = target;
    const { id: nameValue, dataset: { oldValue }, value } = elem;

    if ( value !== oldValue ) {
      elem.dataset.oldValue = value;
      const { dataId } = this;

      const data = { id: dataId, [ nameValue ]: value };
      const caption = `Зміна значення ${ nameValue } з ${ oldValue } на ${ value } [id: ${ dataId }]`;
      const { parentElem: { dataset: { pathUpdate: url } } } = this;

      ( async () => {
        const result = await MyLib.ajax( caption, url, 'post', data, 'json', null, true );
        if ( result.status ) elem.dataset.oldValue = value; else elem.value = oldValue;
      } )( );
    }
  }

  // шапка формы
  headerText( ) {
    const { value: number } = this.parentElem.querySelector( '#number' );
    const { value: date } = this.parentElem.querySelector( '#date' );
    this.parentElem.querySelector( 'h1' ).textContent =
      `Переміщення № ${ number } від ${ date }`;
  }

  // нажатие на кнопочку выход
  clickExit( ) {
    MyLib.assignLocation( this.parentElem.dataset.pathExit );
  }

  clickSend( ) {
    const captionPrices = `Обновлення данних цін та залишків з ІС [id: ${ this.dataId }]`;
    const data = { id: this.dataId };
    const { parentElem: { dataset: { pathUpdatePrice: urlPrices } } } = this;
    const toInstitution = this.parentElem.querySelector( '#to_institution_id' );
    const { options: { [ toInstitution.selectedIndex ]: { disabled: isToInstitution } } } = toInstitution;

    if ( isToInstitution ) {
      const caption = 'Незаповнений реквізит';
      const message = 'Виберіть сад отримувач продуктів';
      objFormSplash.open( 'error', caption, message );
    } else {
      ( async () => {
        const respond = await MyLib.ajax( captionPrices, urlPrices, 'post', data, 'json', null, true );
        if ( respond.status && respond.data ) {
          this.calcPrices( respond.data );
        } else {
          const isCountGtrBalance = await this.countGtrBalance( );
          if ( isCountGtrBalance ) {
            const captionSend = `Відправка данних в ІС [id: ${ this.dataId }]`;

            const successAjaxSend = ( ) => window.location.reload( );
            const { parentElem: { dataset: { pathSend: urlSend } } } = this;

            await MyLib.ajax( captionSend, urlSend, 'post', data, 'json', successAjaxSend, true );
          }
        }
      } )( );
    }
  }

  clickConfirmed( ) {
    const caption = `Підтвердження переміщення [id: ${ this.dataId }]`;
    const data = { id: this.dataId };
    const { parentElem: { dataset: { pathConfirmed: url } } } = this;

    const successAjaxSend = ( ) => window.location.reload( );
    MyLib.ajax( caption, url, 'post', data, 'json', successAjaxSend, true );
  }

  clickEdit( ) {
    const caption = `Редагування переміщення [id: ${ this.dataId }]`;
    const data = { id: this.dataId };
    const { parentElem: { dataset: { pathEdit: url } } } = this;

    const successAjaxSend = ( ) => window.location.reload( );
    MyLib.ajax( caption, url, 'post', data, 'json', successAjaxSend, true );
  }

  countGtrBalance( ) {
    let status = true;

    const balanceLess = [ ];
    this.table.querySelectorAll( 'tr.negative' ).forEach( child => {
      const { textContent: product } = child.querySelector( 'td.name' );
      const balance = +child.querySelector( 'td.balance' ).textContent;
      const count = +child.querySelector( 'td.amount input' ).value;

      balanceLess.push( { 'Продукт:': product, 'Залишок:': balance, 'Кількість:': count } );
    } );

    if ( balanceLess.length ) {
      const caption = 'Загальна кількість по продукту перевищує залишок';
      const message = balanceLess;
      objFormSplash.open( 'error', caption, message );
      status = false;
    }

    return status;
  }

  clickBtnPrices( ) {
    const caption = `Обновлення данних цін та залишків з ІС [id: ${ this.dataId }]`;
    const data = { id: this.dataId };
    const { parentElem: { dataset: { pathUpdatePrice: url } } } = this;

    ( async () => {
      const prices = await MyLib.ajax( caption, url, 'post', data, 'json', null, true );
      if ( prices ) this.calcPrices( prices );
    } )();
  }

  calcPrices( prices ) {
    prices.forEach( value => {
      const row = this.table.querySelector( `tbody tr.row_data[ data-product-id = "${ value.product_id }" ] ` );
      row.querySelector( 'td.balance' ).textContent = MyLib.numToStr( value.balance, -1 );
      row.querySelector( 'td.price' ).textContent = MyLib.numToStr( value.price, -1 );
    } );

    this.calcSum();
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

  clmnInit( ) {
    this.table.querySelectorAll( 'td.price, td.balance' ).forEach( child => {
      const elemChild = child;
      const value = +elemChild.textContent;
      elemChild.textContent = MyLib.numToStr( value, -1 );
    } );

    this.table.querySelectorAll( 'td.amount input' ).forEach( child => {
      const elemChild = child;
      const value = +elemChild.value;
      elemChild.dataset.oldValue = value;
      elemChild.value = MyLib.numToStr( value, -1 );

      elemChild.disabled = this.isDateBlocks || !this.isPost || !this.isEdit;
    } );

    this.calcSum( );
  }

  calcSum( ) {
    this.table.querySelectorAll( 'tbody tr.row_data' ).forEach( tr => {
      const trElem = tr;

      const price = +trElem.querySelector( 'td.price' ).textContent;
      const count =  MyLib.toRound( +trElem.querySelector( 'td.amount input' ).value, 3 );
      const balance = MyLib.toRound( +trElem.querySelector( 'td.balance' ).textContent, 3 );

      const classNegative = 'negative';
      if ( count > balance ) trElem.classList.add( classNegative ); else trElem.classList.remove( classNegative );

      trElem.querySelector( 'td.sum' ).textContent = MyLib.toRound( price * count, 5 ) || '';
    } );
  }

  changeCountProduct( target ) {
    const elem = target;
    const { dataset } = elem;

    const oldValue = +dataset.oldValue;
    const value = MyLib.toNumber( elem.value, 3 );
    const strValue = MyLib.numToStr( value, -1 );

    if ( value === oldValue ) elem.value = strValue;
    else {
      const { name: nameVal } = elem;

      const successAjax = () => {
        elem.value = strValue;
        dataset.oldValue = value;
        this.calcSum( );
      };

      const { id: dataId } = dataset;
      const caption = `Зміна значення ${ nameVal } з ${ oldValue } на ${ value } [id: ${ dataId }]`;
      const data = { id: dataId, [ nameVal ]: value };
      const { clmn: { dataset: { pathUpdate: url } } } = this;
      MyLib.ajax( caption, url, 'post', data, 'json', successAjax, false );
    }
  }
}
