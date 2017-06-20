
// Преобразование в число и обрезание разрядности
const toDecimal = ( value, scale = -1 ) => {
  let result = 0;

  if ( ['number', 'string'].includes(typeof value) ) {
    result = +( new RegExp(
        `(-?\\d+)([.,]${ scale ? '\\d{1,' + (scale === -1 ? '' : scale) + '}' : '' })?`)
      .exec( `${ value }` ) || ['0'] )[0].replace( ',', '.' );
  }

  return result
}

const floatToString = ( value, scale = -1 ) => {
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
};

// Нужно дописать!!!!
const toRound = ( value, scale = 0 ) => {
  let result;
  if ( scale === 2 ) result = Math.round( value * 100) / 100;
  if ( scale === 3 ) result = Math.round( value * 1000) / 1000;


  return result;
}
 /////////////////////////////////////////////////////////////

var $dialogOptions = {
  autoOpen: false,
  resizable: false,
  draggable: false,
  height: "auto",
  width: 400,
  modal: true,
  show: 'slide',
  dialogClass: "dialog-no-close",
  closeOnEscape: false };

var $formatDate = 'DD.MM.YYYY';

moment.locale( 'uk' );


$( document ).on( 'turbolinks:load' , function() {

  SetSession = function ( $key, $param, $value ) { // Запись в сессию
    var $sessionObj = JSON.parse( sessionStorage.getItem( $key ) ) || { } ;//спарсим объект обратно
    var $paramObj = { };
    $paramObj[ $param ] = $value;
    $.extend( $sessionObj, $paramObj ); // Обьединие масивов
    sessionStorage.setItem( $key, JSON.stringify( $sessionObj ) );
  };

  GetSession = function ( $key, $param ) { // Чтение из сессии
    var $sessionObj = JSON.parse( sessionStorage.getItem( $key ) ) || { } ;//спарсим объект обратно
    return $sessionObj[ $param ] || '' ;
  };






  // // Проверка значения
  // floatValue = function($value) {
  //   var $returnValue = '' ;
  //   if (typeof($value) != 'undefined') { $returnValue = $value.toString().replace(',','.').replace(' ','') };
  //   if ( $.isNumeric($returnValue) ) { $returnValue = parseFloat( $returnValue ) } else { $returnValue = 0 };
  //   return $returnValue
  // };
  //
  // float3Value = function( $value ) {
  //   return Math.trunc( (floatValue( $value ) + 0.0001) * 1000 ) / 1000;
  // }
  //
  // f3_to_s = function($value) {
  //   return $value ? `${ floatValue( $value ) }`.match(/-?\d+(\.\d{1,3})?/)[0] : ''
  // }
  //
  // f_to_s = function($value) {
  //   return $value ? $value : ''
  // }
  //
  //   f2_to_s = function($value) {
  //   return $value ? $value.toFixed(2) : ''
  // }
  //
  // IntToString = function($value) {
  //   return $value ? $value : ''
  // }


 getScrollbarWidth = function($value) {
    var outer = document.createElement("div");
    outer.style.visibility = "hidden";
    outer.style.width = "100px";
    document.body.appendChild(outer);

    var widthNoScroll = outer.offsetWidth;
    // force scrollbars
    outer.style.overflow = "scroll";

    // add innerdiv
    var inner = document.createElement("div");
    inner.style.width = "100%";
    outer.appendChild(inner);

    var widthWithScroll = inner.offsetWidth;

    // remove divs
    outer.parentNode.removeChild(outer);

    return widthNoScroll - widthWithScroll;
  }


  // При получении фокуса выделяем весь текст и сохраянем старое значение
  $('input[type="number"], input[type="text"]').focus( function() {
    var $this = $(this);
    $this.data('old-value', $this.val()).select();
  });

  //-------------------------------------------------------------
  // Диалог ожидания
  $( "#dialog_wait" ).dialog( $dialogOptions );
  //-------------------------------------------------------------

});
