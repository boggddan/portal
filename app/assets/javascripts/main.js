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






  // Проверка значения
  floatValue = function($value) {
    var $returnValue = '' ;
    if (typeof($value) != 'undefined') { $returnValue = $value.toString().replace(',','.').replace(' ','') };
    if ( $.isNumeric($returnValue) ) { $returnValue = parseFloat( $returnValue ) } else { $returnValue = 0 };
    return $returnValue
  };

  float3Value = function( $value ) {
    return Math.trunc( (floatValue( $value ) + 0.0001) * 1000 ) / 1000;
  }

  f3_to_s = function($value) {
    return $value ? float3Value( $value ).toFixed(3) : ''
  }

  f_to_s = function($value) {
    return $value ? $value : ''
  }

    f2_to_s = function($value) {
    return $value ? $value.toFixed(2) : ''
  }

  IntToString = function($value) {
    return $value ? $value : ''
  }


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

  // Диалог удаления
   $( '#dialog_delete' ).dialog( {
   autoOpen: false,
   resizable: false,
   height: 'auto',
   width: 400,
   modal: true,
   buttons: {
     'Так': function() {
       var $this = $( this );
         if ( $( '#menu_requirements' ).length == 0 ) { eval( $this.data( 'delete' ) ) }
         else { $this.trigger( 'delete' ) }
       $this.dialog( 'close' );
     },
      'Hі': function() {
       var $this = $( this );

       if ( $( '#menu_requirements' ).length == 0 && $( '#timesheets' ).length ) { eval( $this.data( 'un-delete' )) }
       else { $this.trigger( 'un_delete' ) }

       $this.dialog( 'close' );
     }
   }});

});
