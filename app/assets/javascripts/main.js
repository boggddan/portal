/* exported MyLib */

class MyLib {
  static get formatDate( ) { return 'DD.MM.YYYY' }

  // преобразование в число и обрезание разрядности
  static toNumber( value, scale = -1 ) {
    let result = 0;

    if ( [ 'number', 'string' ].includes( typeof value ) ) {
      result = +( new RegExp(
        `(-?\\d+)([.,]${ scale ? `\\d{1,${ scale === -1 ? '' : scale }}` : '' })?` )
        .exec( `${ value }` ) || [ '0' ] )[ 0 ].replace( ',', '.' );
    }

    return result;
  }

  static numToStr( value, scale = -1 ) {
    let result = '';

    if ( value ) {
      const strValue = value.toString();

      if ( scale === -1 ) result = strValue;
      else {
        let scaleValue = '';
        const arrValue = strValue.split( '.' );
        if ( scale === 0 ) ( { 0: result } = arrValue );
        else {
          if ( arrValue.length === 1 ) scaleValue = '0'.repeat( scale );
          else {
            const { 1: { length: arrScaleLen } } = arrValue;
            scaleValue = ( arrValue[ 1 ] +
              ( scale > arrScaleLen ? '0'.repeat( scale - arrScaleLen ) : '' ) ).slice( 0, scale );
          }
          result = `${ arrValue[ 0 ] }.${ scaleValue }`;
        }
      }
    }

    return result;
  }

  // нужно дописать!!!!
  static toRound( value, scale = 0 ) {
    let result = 0;
    if ( scale === 0 ) result = Math.round( value );
    if ( scale === 2 ) result = Math.round( value * 100 ) / 100;
    if ( scale === 3 ) result = Math.round( value * 1000 ) / 1000;

    return result;
  }

  static toDateFormat( value ) {
    return value ? moment( value, 'YYYY-MM-DD' ).format( 'L' ) : '';
  }

  static camelize( value ) {
    return value.toLowerCase( )
      .replace( /[-_](.)/g, word => word[ 1 ].toUpperCase() );
  }

  static kebab( value ) {
    return value
      .replace( /([A-Z])/g, '-$1' )
      .replace( /_/g, '-' )
      .replace( /(-+)/g, '-' )
      .toLowerCase();
  }

  // изминение значение таблице и на панели
  static changeValue( elem, parentName, callback ) {
    const name = elem.attr( 'name' ) || elem.attr( 'id' );
    const dataType = elem.data( 'type' );
    let [ val, valOld ] = [ 0, 0 ];

    if ( dataType && dataType.charAt( 0 ) === 'n' ) {
      const scale = +dataType.slice( 1 ) || -1;
      val = this.toNumber( elem.val( ), scale );
      valOld = +elem.data( 'old-value' );
      const strVal = this.numToStr( val );

      elem.val( strVal ).attr( 'value', strVal );
    } else {
      val = elem.val( );
      valOld = elem.data( 'old-value' );
    }

    let parentElem = HTMLElement;
    let id = -1;

    switch ( parentName ) {
      case 'tr': {
        parentElem = elem.closest( '.clmn' );
        id = elem.closest( parentName ).data( 'id' );
        break;
      }
      case 'main': {
        parentElem = elem.closest( 'main' );
        id = parentElem.data( 'id' );
      }

      // no default
    }

    if ( val !== valOld && id !== -1 ) {
      elem.data( 'old-value', val );
      this.ajax(
        `Зміна значення ${ name } з ${ valOld } на ${ val } [id: ${ id }]`,
        parentElem.data( 'path-update' ),
        'post',
        { id, [ name ]: val },
        'json',
        callback,
        false );
    }
  }

  static mainMenuActive( selector ) {
    const menuItem = document.querySelector( `#main_menu li[data-page='${ selector }']` );
    if ( menuItem ) {
      Array.from( menuItem.parentElement.children ).forEach( child => {
        const { classList } = child;
        if ( child === menuItem ) classList.add( 'active' ); else classList.remove( 'active' );
      } );
    }
  }

  static ajax( caption, url, type, dataValue, dataType, callSuccess, loader = true ) {
    let result = null;
    this.pageLoader( loader );

    const scriptRun = text => {
      const script = document.createElement( 'script' );
      script.innerHTML = text;
      document.head.appendChild( script );
    };

    const success = data => {
      let returnSuccess = null;

      if ( dataType === 'json' ) {
        const { caption: dataCaption = caption, message: dataMessage, status: dataStatus } = data;

        let dataMessageContent = '';
        if ( dataMessage ) dataMessageContent = `<pre>${ JSON.stringify( dataMessage, null, 2 ) }</pre>`;

        if ( dataStatus ) {
          const { href, view, data: dataData } = data;
          if ( href ) {
            if ( href.search( /.pdf$/i ) === -1 ) this.assignLocation( href );
            else objFormSplash.open( 'print', caption, href );
          } else if ( view ) {
            document.getElementById( 'view' ).innerHTML = view;
          } else if ( dataMessage ) {
            objFormSplash.open( 'info', dataCaption, dataMessageContent );
            returnSuccess = dataData;
          }

          if ( callSuccess ) callSuccess( );
        } else {
          objFormSplash.open( 'error', dataCaption, dataMessageContent );
        }
      } else if ( dataType === 'script' ) {
        scriptRun( data );
      }

      if ( loader ) this.pageLoader( false );

      return returnSuccess;
    };

    const sendAjax = async ( ) => {
      let data = '';
      const headers = { 'Content-Type': 'application/json' };
      const body = JSON.stringify( dataValue || { empty: '' } );

      const credentials = 'same-origin';
      const respond = await fetch( url, { method: type, body, headers, credentials, redirect: "error"} );

      if ( respond.ok ) {
        if ( dataType === 'json' ) {
          data = await respond.json( );
        } else if ( dataType === 'script' ) {
          data = await respond.text( );
        }
      } else {
        data = await respond.text( );
        throw new Error( data );
      }

      return data;
    };

    return sendAjax( )
      .then( data => success( data ) )
      .catch( reason => objFormSplash.open( 'error', caption, reason ) );
  }

  // нажатие на кнопочку выход
  static btnExitClick( elem ) {
    this.pageLoader( true );
    window.location.replace( elem.closest( 'main' ).data( 'path-exit' ) );
  }

  static pageLoader( isEnabled ) {
    const { classList } = document.querySelector( '.preloader' );
    if ( isEnabled ) classList.add( 'show' ); else classList.remove( 'show' );
  }

  static capitalize( str ) {
    return `${ str.charAt( 0 ).toUpperCase( ) }${ str.slice( 1 ) }`;
  }

  static assignLocation( siteUrl, urlParams = { } ) {
    this.pageLoader( true );

    const serializeParams = params =>
      Object.keys( params ).reduce( ( acc, cur ) =>
        `${ acc }&${ cur }=${ encodeURIComponent( params[ cur ] ) }`, '' )
        .replace( /^&/, '?' );

    window.location.assign( `${ siteUrl }${ serializeParams( urlParams ) }` );
  }

  static initValue( elem ) {
    const tagName = elem.prop( 'tagName' );
    const dataType = elem.data( 'type' );

    let val = tagName === 'INPUT' ? elem.val( ) : elem.text( );

    if ( dataType && dataType.charAt( 0 ) === 'n' ) {
      const scale = +dataType.slice( 1 ) || -1;
      val = this.toNumber( val, scale );
      const valFmt = this.numToStr( val );
      if ( tagName === 'INPUT' ) elem.val( valFmt ); else elem.text( valFmt );
    }

    elem.data( 'old-value', val );
  }

  static btnSendClick( elem ) {
    const { dataset: { id, pathSend: url } } = elem[ 0 ].closest( 'main' );
    const caption = `Відправка данних в ІС [id: ${ id }]`;
    const successAjax = ( ) => window.location.reload( );
    this.ajax( caption, url, 'post', { id }, 'json', successAjax, true );
  }

  static btnPrintClick( elem ) {
    const { dataset: { id, pathPrint: url } } = elem[ 0 ].closest( 'main' );
    const caption = `Формування звіта в ІС [id: ${ id }]`;
    this.ajax( caption, url, 'post', { id }, 'json', null, true );
  }

  static clickHeader( elem ) {
    elem.toggleClass( 'hide' );
    if ( elem.prop( 'tagName' ) === 'H1' ) {
      $( '.panel_main' ).toggleClass( 'hide' );
    } else {
      elem.siblings( ).toggleClass( 'hide' );
    }
  }

  // сообщение об ошибке
  static delMsg( header, callback ) {
    $( '#del_msg' )
      .removeClass( 'hide' )
      .find( '.caption' ).text( header )
      .end( )
      .find( '.success' )
      .one( 'click', ( ) => {
        $( '#del_msg' ).addClass( 'hide' );
        callback( );
      } );
  }

  // нажатие на кнопочку создать
  static createDoc( elem, data ) {
    const { dataset } = elem[ 0 ].closest( '.clmn' );
    const caption = `Сторення: ${ dataset.caption }`;
    this.ajax( caption, dataset.pathCreate, 'post', data, 'json', null, true );
  }

  // проверка на соотвествие типа, является ли объетом
  static isObject( item ) {
    return item && typeof item === 'object' && !Array.isArray( item );
  }

  // соеднинение двох объектов с мержирование ключей
  static mergeDeep( target, source ) {
    if ( this.isObject( target ) && this.isObject( source ) ) {
      Object.keys( source ).forEach( key => {
        if ( this.isObject( source[ key ] ) ) {
          if ( !target[ key ] ) Object.assign( target, { [ key ]: { } } );
          this.mergeDeep( target[ key ], source[ key ] );
        } else {
          Object.assign( target, { [ key ]: source[ key ] } );
        }
      } );
    }

    return target;
  }

  // запись в сессию
  static setSession( key, value ) {
    const sessionObj = JSON.parse( sessionStorage.getItem( key ) ) || { }; // спарсим объект обратно
    this.mergeDeep( sessionObj, value ); // обьединие масивов
    sessionStorage.setItem( key, JSON.stringify( sessionObj ) );
  }

  // запись в сессию
  static setClearTableSession( key, keyTable ) {
    const sessionObj = JSON.parse( sessionStorage.getItem( key ) ) || { }; // спарсим объект обратно
    if ( sessionObj[ keyTable ] ) {
      delete sessionObj[ keyTable ].rowId;
      delete sessionObj[ keyTable ].scrollTop;
      sessionStorage.setItem( key, JSON.stringify( sessionObj ) );
    }
  }

  // запись в сессию
  static setDeleteElemSession( key, elem ) {
    const sessionObj = JSON.parse( sessionStorage.getItem( key ) ) || { }; // спарсим объект обратно
    if ( sessionObj ) {
      delete sessionObj[ elem ];
      sessionStorage.setItem( key, JSON.stringify( sessionObj ) );
    }
  }

  // чтение из сессии
  static getSession( key ) {
    return JSON.parse( sessionStorage.getItem( key ) ) || { };
  }

  static getSessionKey( elem ) {
    return $( elem ).closest( 'main' ).attr( 'id' );
  }

  static getSessionClmnKey( elem ) {
    return elem.closest( '.clmn' ).attr( 'id' );
  }

  // начальная дата фильтрации
  static selectDateStart( elem, dateEndId, callBack ) {
    const elemVal =  elem.val( );

    if ( elemVal !== elem.data( 'old-value' ) ) {
      const sessionKey = this.getSessionKey( elem );
      this.setSession( sessionKey, { dateStart: elemVal } );
      elem.data( 'old-value', elemVal );
      const dateEnd = $( dateEndId );
      const dateEndVal = dateEnd.val( );

      if ( !dateEndVal ||
        moment( elemVal, this.formatDate ).isAfter( moment( dateEndVal, this.formatDate ) ) ) {
        this.setSession( sessionKey, { dateEnd: elemVal } );
        dateEnd.val( elemVal ).data( 'old-value', elemVal );
      }
      if ( callBack ) callBack( );
    }
  }

  // конечная дата фильтрации
  static selectDateEnd( elem, dateStartId, callBack ) {
    const elemVal = elem.val( );

    if ( elemVal !== elem.data( 'old-value' ) ) {
      const sessionKey = this.getSessionKey( elem );
      this.setSession( sessionKey, { dateEnd: elemVal } );
      elem.data( 'old-value', elemVal );
      const dateStart = $( dateStartId );
      const dateStartVal = dateStart.val( );

      if ( !dateStartVal || moment( elemVal, this.formatDate ).isBefore( moment( dateStartVal, this.formatDate ) ) ) {
        this.setSession( sessionKey, { dateStart: elemVal } );
        dateStart.val( elemVal ).data( 'old-value', elemVal );
      }
      if ( callBack ) callBack( );
    }
  }

  // нажатие на строку в табичке
  static rowClick( elem, callBack ) {
    const className = 'selected';
    const { id: sessionKey } = elem.closest( 'main' );
    const { id: clmnKey } = elem.closest( '.clmn' );
    this.setSession( sessionKey, { [ clmnKey ]: { rowId: elem.dataset.id } } );

    Array.from( elem.parentElement.children ).forEach( child => {
      if ( child === elem ) child.classList.add( className ); else child.classList.remove( className );
    } );

    if ( callBack ) callBack( );
  }

  static tableEditClick( elem ) {
    const { dataset: { pathView: url } } = elem.closest( '.clmn' );
    const { dataset: { id } } = elem.closest( 'tr' );

    MyLib.assignLocation( url, { id } ); // для перехода в табличную часть
  }

  static tableDelClick( elem, callBack ) {
    const table = elem.closest( 'table' );
    const tr = elem.closest( 'tr' );

    const { id: key } =  elem.closest( 'main' );
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
  static tableHeaderClick( elem, callBack ) {
    const { classList, dataset } = elem;
    const classOrder = { add: 'desc', remove: 'asc' };
    const { id: key } =  elem.closest( 'main' );
    const { id: clmnKey } = elem.closest( '.clmn' );

    if ( classList.contains( classOrder.add ) ) [ classOrder.add, classOrder.remove ] = [ classOrder.remove, classOrder.add ];
    classList.remove( classOrder.remove );
    classList.add( classOrder.add );
    const value = { [ clmnKey ]: { sortField: dataset.sort, sortOrder: classOrder.add } };

    MyLib.setSession( key, value );
    if ( callBack ) callBack( ); // фильтрация таблицы документов
  }

  static tableSetSession( parentTable ) {
    const elem = parentTable instanceof $ ? parentTable[ 0 ] : parentTable;
    const { id: sessionKey } = elem.closest( 'main' );
    const { id: clmnKey } = elem.closest( '.clmn' );

    const table = elem.querySelector( 'table' );
    $( table ).tableHeadFixer( ); // фиксируем шапку таблицы

    elem.addEventListener( 'scroll', event => this.setSession( sessionKey, { [ clmnKey ]: { scrollTop: event.target.scrollTop } } ) );
    const { [ clmnKey ]: clmnObj } = this.getSession( sessionKey );

    if ( clmnObj ) {
      const { sortField, sortOrder, scrollTop, rowId } = clmnObj;
      if ( sortField ) table.querySelector( `th[data-sort='${ sortField }']` ).classList.add( sortOrder );

      if ( scrollTop ) elem.scrollTop = scrollTop;

      if ( rowId ) {
        const tr = table.querySelector( `tr[data-id='${ rowId }']` );
        if ( tr ) tr.classList.add( 'selected' );
        else this.setSession( sessionKey, { [ clmnKey ]: { rowId: 0 } } );
      }
    }
  }
}

let objMenuRequirementProducts = { };
let objTimesheetDates = { };
let objUsers = { };
let objUserNew = { };
let objLogIn = { };
let objDishesProductsNorms = { };

const userInfo = new UAParser( ).getResult( );

$( document ).on( 'turbolinks:load', ( ) => {
  moment.locale( 'uk' );

  $( '#del_msg button:not( success )' )
    .on( 'click', ( ) =>
      $( '#del_msg' ).addClass( 'hide' ).find( '.success' ).off( 'click' ) );

  const elemMenuRequirementProducts = document.getElementById( 'menu_requirement_products' );
  const elemTimesheetDates = document.getElementById( 'timesheet_dates' );
  const elemUsers = document.getElementById( 'users' );
  const elemUserNew = document.getElementById( 'user_new' );
  const elemLogIn = document.getElementById( 'log_in' );
  const elemDishesProductsNorms = document.getElementById( 'dishes_products_norms' );

  const elemFormSplash = document.getElementById( 'form_splash' );
  if ( elemFormSplash ) objFormSplash = new FormSplash( elemFormSplash );

  if ( elemMenuRequirementProducts ) objMenuRequirementProducts = new MenuRequirementProducts( elemMenuRequirementProducts );
  else if ( elemTimesheetDates ) objTimesheetDates = new TimesheetDates( elemTimesheetDates );
  else if ( elemUsers ) objUsers = new Users( elemUsers );
  else if ( elemUserNew ) objUserNew = new UserNew( elemUserNew );
  else if ( elemLogIn ) objLogIn = new LogIn( elemLogIn );
  else if ( elemDishesProductsNorms ) objDishesProductsNorms = new DishesProductsNorms( elemDishesProductsNorms );
} );
