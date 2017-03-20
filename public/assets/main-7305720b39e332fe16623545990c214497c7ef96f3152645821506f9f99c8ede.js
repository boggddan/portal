$( document ).on('turbolinks:load', function() {

  // Проверка значения
  floatValue = function($value)  {
    var $returnValue = '' ;
    if (typeof($value) != 'undefined') { $returnValue = $value.toString().replace(',','.').replace(' ','') };
    if ( $.isNumeric($returnValue) ) { $returnValue = parseFloat( $returnValue ) } else { $returnValue = 0 };
    return $returnValue
  };

  f3_to_s = function($value) {
    return $value ? $value.toFixed(3) : ''
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
  $( "#dialog_wait" ).dialog({
    autoOpen: false,
    resizable: false,
    draggable: false,
    height: "auto",
    width: 400,
    modal: true,
    show: 'slide',
    dialogClass: "dialog-no-close",
    closeOnEscape: false
  });
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
       eval( $( this ).data( 'delete' ) );
       $( this ).dialog( 'close' );
     },
      'Hі': function() {
       eval( $( this ).data( 'un-delete' ));
       $( this ).dialog( 'close' );
     }
   }});

});
