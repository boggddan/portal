class MyLib {
  static get formatDate( ) { return 'DD.MM.YYYY' }

  // Преобразование в число и обрезание разрядности
  static toNumber( value, scale = -1 ) {
    let result = 0;

    if ( ['number', 'string'].includes(typeof value) ) {
      result = +( new RegExp(
        `(-?\\d+)([.,]${ scale ? '\\d{1,' + (scale === -1 ? '' : scale) + '}' : '' })?`)
        .exec( `${ value }` ) || ['0'] )[0].replace( ',', '.' );
    }

    return result;
  }

  static numToStr( value, scale = -1 ) {
    let result = '';

    if ( value ) {
      const strValue = value.toString();

      if ( scale === -1 ) result = strValue;
      else {
        let scaleValue;
        const arrValue = strValue.split('.');
        if ( scale === 0 ) result = arrValue[ 0 ];
        else {
          if ( arrValue.length === 1 ) scaleValue = '0'.repeat( scale );
          else {
            const arrScaleLen = arrValue[ 1 ].length;
            scaleValue = ( arrValue[ 1 ] +
              ( scale > arrScaleLen ? '0'.repeat( scale - arrScaleLen ) : '' ) ).slice( 0, scale );
          }
          result = arrValue[ 0 ] + '.' + scaleValue;
        }
      }
    }

    return result;
  }

  // Нужно дописать!!!!
  static toRound( value, scale = 0 ) {
    let result;
    if ( scale === 0 ) result = Math.round( value );
    if ( scale === 2 ) result = Math.round( value * 100 ) / 100;
    if ( scale === 3 ) result = Math.round( value * 1000 ) / 1000;

    return result;
  }

  // Изминение значение таблице и на панели
  static changeValue( elem, parentName, callback ) {
    const name = elem.attr( 'name' ) || elem.attr( 'id' );
    const dataType = elem.data( 'type' );
    let val;
    let valOld;

    if ( dataType && dataType.charAt(0) === 'n' ) {
      const scale = +dataType.slice(1) || -1;
      val = this.toNumber( elem.val( ), scale );
      valOld = +elem.data( 'old-value' );
      const strVal = this.numToStr( val );

      elem.val( strVal ).attr( 'value', strVal );
    } else {
      val = elem.val( );
      valOld =  elem.data( 'old-value' );
    }

    let parentElem;
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
        { id: id, [name]: val },
        'json',
        '',
        callback,
        false );
    }
  }

  static ajax( caption, url, type, data, dataType, urlAssing, callsuccess, loader = true ) {
    this.pageLoader( loader );

    $.ajax(
      { url: url,
        type: type,
        data: data,
        dataType: dataType,
        success: data => {
          if ( dataType === 'json' ) {
            if ( data.status ) {
              if ( urlAssing ) this.assignLocation( urlAssing, data.urlParams );
              const href = data.href;
              const view = data.view;
              if ( href ) {
                if ( href.search(/.pdf$/i) === -1 ) this.assignLocation( href ); else this.open( href );
              }
              if ( view ) $( '#view' ).html( view );
              if ( callsuccess ) callsuccess( );
            } else {
              this.errorMsg( data.caption || caption, JSON.stringify( data.message, null, ' ' ) );
            }
          }

          if ( loader ) this.pageLoader( false );
        },
        error: xhr => { this.errorMsg( caption, xhr.responseText ) }
      }
    );
  }

  // Нажатие на кнопочку выход
  static btnExitClick(elem) {
    this.pageLoader( true );
    window.location.replace( elem.closest( 'main' ).data( 'path-exit' ) );
  }

  static pageLoader( is_enabled ) {
    if ( is_enabled ) $( '.preloader' ).addClass( 'show' ); else $( '.preloader' ).removeClass( 'show' );
  }

  static capitalize( str ) {
    return `${ str.charAt( 0 ).toUpperCase( ) }${ str.slice( 1 ) }`;
  }

  static assignLocation( siteUrl, urlParams =  {} ) {
    this.pageLoader( true );

    const serializeParams = params =>
      Object.keys( params ).reduce( ( acc, cur ) =>
        acc += `&${ cur }=${ encodeURIComponent( params[cur] ) }`
        , '').replace(/^&/, '?');

    window.location.assign( `${ siteUrl }${ serializeParams( urlParams ) }` );
  }

  static initValue( elem ) {
    const tagName = elem.prop( 'tagName' );
    const dataType = elem.data( 'type' );

    let val = tagName === 'INPUT' ? elem.val( ) : elem.text( );

    if ( dataType && dataType.charAt( 0 ) === 'n' ) {
      const scale = +dataType.slice(1) || -1;
      val = this.toNumber( val, scale );
      const valFmt = this.numToStr( val );
      if ( tagName === 'INPUT' ) elem.val( valFmt ); else elem.text( valFmt );
    }

    elem.data( 'old-value', val );
  }

  static btnSendClick( elem ) {
    this.pageLoader( true );
    const main = elem.closest( 'main' );
    const id = main.data( 'id' );

    this.ajax(
      `Відправка данних в 1С [id: ${ id }]`,
      main.data( 'path-send' ),
      'post',
      { id: id, bug: '' },
      'json',
      false,
      ( ) => window.location.reload( ),
      true );
  }

  static btnPrintClick( elem ) {
    this.pageLoader( true );
    const main = elem.closest( 'main' );
    const id = main.data( 'id' );

    this.ajax(
      `Формування звіта в 1С [id: ${ id }]`,
      main.data( 'path-print' ),
      'post',
      { id: id, bug: '' },
      'json',
      false,
      false,
      true );
  }

  static clickHeader( elem ) {
    elem.toggleClass( 'hide' );
    if ( elem.prop( 'tagName' ) === 'H1' ) {
      $( '.panel_main' ).toggleClass( 'hide' );
    } else {
      elem.siblings( ).toggleClass( 'hide' );
    }
  }

  // Сообщение об ошибке
  static errorMsg( header = '', message = '' ) {
    this.pageLoader( false );
    $( '#error_msg' )
      .removeClass( 'hide' )
      .find( '.caption' ).text( header )
      .end( )
      .find( '.text' ).text( message );
  }

  // Сообщение об ошибке
  static delMsg( header, callback ) {
    $( '#del_msg' )
      .removeClass( 'hide' )
      .find( '.caption' ).text( header )
      .end( )
      .find( '.success' ).one( 'click', ( ) => {
        $('#del_msg').addClass( 'hide' );
        callback( );
      } );
  }

  // Нажатие на кнопочку создать
  static createDoc( elem, data ) {
    const dataAttr = $( elem ).closest( '.clmn' ).data( );

    this.ajax(
      `Сторення: ${ dataAttr.caption } `,
      dataAttr.pathCreate,
      'post',
      data,
      'json',
      dataAttr.pathView );
  }


  // Проверка на соотвествие типа, является ли объетом
  static isObject(item) {
    return item && typeof item === 'object' && !Array.isArray( item );
  }

  // Соеднинение двох объектов с мержирование ключей
  static mergeDeep(target, source) {
    if ( this.isObject( target ) && this.isObject( source ) ) {
      Object.keys(source).forEach( key => {
        if ( this.isObject( source[ key ] ) ) {
          if ( !target[ key ] ) Object.assign( target, { [ key ]: { } } );
          this.mergeDeep( target[ key ], source[ key ] );
        } else {
          Object.assign( target, { [ key ]: source[key] } );
        }
      } );
    }
    return target;
  }

  // Запись в сессию
  static setSession( key, value ) {
    const sessionObj = JSON.parse( sessionStorage.getItem( key ) ) || { }; // спарсим объект обратно
    this.mergeDeep( sessionObj, value ); // Обьединие масивов
    sessionStorage.setItem( key, JSON.stringify( sessionObj ) );
  }

  // Запись в сессию
  static setClearTableSession( key, keyTable ) {
    const sessionObj = JSON.parse( sessionStorage.getItem( key ) ) || { }; // спарсим объект обратно
    if ( sessionObj[ keyTable ] ) {
      delete sessionObj[ keyTable ].row_id;
      delete sessionObj[ keyTable ].scroll_top;
      sessionStorage.setItem( key, JSON.stringify( sessionObj ) );
    }
  }

  // Запись в сессию
  static setDeleteElemSession( key, elem ) {
    const sessionObj = JSON.parse( sessionStorage.getItem( key ) ) || { }; // спарсим объект обратно
    if ( sessionObj ) {
      delete sessionObj[ elem ];
      sessionStorage.setItem( key, JSON.stringify( sessionObj ) );
    }
  }

  // Чтение из сессии
  static getSession( key ) {
    return JSON.parse( sessionStorage.getItem( key ) ) || { };
  }

  static getSessionKey( elem ) {
    return elem.closest( 'main' ).attr( 'id' );
  }

  static getSessionClmnKey( elem ) {
    return elem.closest( '.clmn' ).attr( 'id' );
  }

  // Начальная дата фильтрации
  static selectDateStart( elem, dateEndId, callback ) {
    const elemVal =  elem.val( );

    if ( elemVal !== elem.data( 'old-value' ) ) {
      const sessionKey = this.getSessionKey( elem );
      this.setSession( sessionKey, { date_start: elemVal } );
      elem.data( 'old-value', elemVal );
      const dateEnd = $( dateEndId );
      const dateEndVal = dateEnd.val( );

      if ( !dateEndVal || moment( elemVal, this.formatDate ).isAfter( moment( dateEndVal, this.formatDate ) ) ){
        this.setSession( sessionKey, { date_end: elemVal } );
        dateEnd.val( elemVal ).data( 'old-value', elemVal );
      }
      if ( callback ) callback( );
    }
  }

  // Конечная дата фильтрации
  static selectDateEnd( elem, dateStartId, callback ) {
    const elemVal = elem.val( );

    if ( elemVal !== elem.data( 'old-value' ) ) {
      const sessionKey = this.getSessionKey( elem );
      this.setSession( sessionKey, { date_end: elemVal } );
      elem.data( 'old-value', elemVal );
      const dateStart = $( dateStartId );
      const dateStartVal = dateStart.val( );

      if ( !dateStartVal || moment( elemVal, this.formatDate ).isBefore( moment( dateStartVal, this.formatDate ) ) ) {
        this.setSession( sessionKey, { date_start: elemVal } );
        dateStart.val( elemVal ).data( 'old-value', elemVal );
      }
      if ( callback ) callback( );
    }
  }

  // Нажатие на строку в табичке
  static rowSelect( elem, callback ) {
    elem.addClass( 'selected' ).siblings().removeClass( 'selected' );
    this.setSession(
      this.getSessionKey( elem ),
      { [ MyLib.getSessionClmnKey( elem) ]: { row_id: elem.data( 'id' ) } } );
    if ( callback ) callback( );
  }

  // Нажатие на кнопочку в табичке
  static tableButtonClick( elem, callbackDel ) {
    const clmn = $( elem ).closest( '.clmn' );
    const dataAttr = clmn.data( );
    const table = elem.closest( 'table' );

    const tr = elem.closest( 'tr' );
    const trId = tr.data( 'id' );

    // удалить
    if ( elem.hasClass('btn_del') ) {
      const msgDelCaption = `${ dataAttr.caption } \
        № ${ tr.children( 'td[data-field=number]' ).text( ) } \
        від ${ tr.children( 'td[data-field=date]' ).text( ) }`;

      this.delMsg(
        msgDelCaption,
        ( ) => {
          MyLib.ajax(
            `Видалення: ${ msgDelCaption } [id: ${ trId }]`,
            dataAttr.pathDel,
            'delete',
            { id: trId, bug: '' },
            'json',
            '',
            ( ) => {
              if ( table.find( 'tbody tr' ).length === 1 ) table.remove( ); else tr.remove( );
              this.setClearTableSession( this.getSessionKey( clmn ), clmn.attr( 'id' ) );
              if ( callbackDel ) callbackDel( );
            },
            true );
        }
      );
    } else {
      this.assignLocation( dataAttr.pathView, { id: trId } ); // для перехода в табличную часть
    }
  }

  // Нажатие для сортировки
  static tableHeaderClick( elem, callback ) {
    const classOrder = { add: 'desc', remove: 'asc'};

    if ( elem.hasClass( classOrder.add ) ) [ classOrder.add, classOrder.remove ] = [ classOrder.remove,  classOrder.add ];
    elem.removeClass( classOrder.remove ).addClass( classOrder.add );

    this.setSession(
      this.getSessionKey( elem ),
      { [ this.getSessionClmnKey( elem ) ]: { sort_field:  elem.data( 'sort' ), sort_order: classOrder.add } } );
    callback( ); // Фильтрация таблицы документов
  }

  static tableSetSession( elem ) {
    const sessionKey = this.getSessionKey( elem );
    const clmn =  $( elem ).closest( '.clmn' );
    const clmnKey = clmn.attr( 'id' );
    const sessionObj = this.getSession( sessionKey )[ clmnKey ];
    elem
      .children( 'table' ).tableHeadFixer( ) // Фиксируем шапку таблицы
      .end( )
      .scroll( ( ) => this.setSession( sessionKey, { [ clmnKey ]: { scroll_top: elem.scrollTop( ) } } ) );

    if ( sessionObj ) {
      if ( sessionObj.sort_field ) {
        elem.find( `th[data-sort=${ sessionObj.sort_field }]`).addClass( sessionObj.sort_order );
      }

      if ( sessionObj.scroll_top ) {
        elem.scrollTop( sessionObj.scroll_top );
      }

      if ( sessionObj.row_id ) {
        const row = elem.find( `tr[data-id=${ sessionObj.row_id } ]` );
        if ( row ) row.addClass( 'selected' ); else this.setSession( sessionKey, { [ clmnKey ]: { row_id: 0 } } );
      }
    }
  }

  static existElem( elem ) {
    return elem.length > 0 ? true : false;
  }

}


let objMenuRequirementProducts;
let objTimesheetDates;

$( document ).on( 'turbolinks:load', ( ) => {
  moment.locale( 'uk' );

  $( '#error_msg .close' )
    .on( 'click', ( ) => $( '#error_msg' ).addClass( 'hide' ));

  $( '#del_msg button:not( success )' )
    .on( 'click', ( ) =>
      $( '#del_msg' ).addClass( 'hide' ).find( '.success' ).off( 'click' ));

  const elemMenuRequirementProducts = $( '#menu_requirement_products' );
  const elemTimesheetDates = $( '#timesheet_dates' );

  if ( elemMenuRequirementProducts.length ) {
    objMenuRequirementProducts = new MenuRequirementProducts( elemMenuRequirementProducts );
  } else if ( elemTimesheetDates.length ) {
    objTimesheetDates = new TimesheetDates( elemTimesheetDates );
  }

} );
