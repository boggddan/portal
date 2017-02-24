$( document ).on('turbolinks:load', function() {

  // Заголовок формы Ввода поступлений продуктов
  function receiptProductsHeader() {
    var $invoice_number = $('#receipt-products #invoice_number');
    var $date_val = $('#receipt-products #date_dp').val();
    var $val = $invoice_number.data('text-before')+' '+ $invoice_number.val() +' '+$invoice_number.data('text-after')+' '+$date_val;
    $('#receipt-products #text-header').text($val);
  };



  // Номер накладной - при потери фокуса сохраняем значение
  $('#receipt-products #invoice_number').blur( function() {
    var $this = $(this);
    if ( $this.data( 'old-value') != $this.val() ) {
      receiptProductsHeader(); // Заголовок формы Ввода поступлений продуктов
      $this.parents('form').submit();
    };
  });

  // Номер накладной - при получении фокуса выделяем весь текст
  $('#receipt-products #invoice_number').focus( function() {
    var $this = $(this);
    $this.data('old-value', $this.val()).select();
  });
  //-------------------------------------------------------------

  //-------------------------------------------------------------
  // Виджет --- Дата накладной - при выборе сохраняем значение
  $('#receipt-products #date_dp').datepicker({
    onSelect: function() {
      var $this = $(this);
      var $dateValue  = $.datepicker.formatDate('yy-mm-dd',  $this.datepicker("getDate"));
      var $dateField = $('#receipt-products #date');
      if ( $dateField.val() != $dateValue ) {
        receiptProductsHeader(); // Заголовок формы Ввода поступлений продуктов
        $dateField.val($dateValue);
        $this.prop('disabled', true);
        $this.parents('form').submit();
        $this.prop('disabled', false); }; }
  });
  //-------------------------------------------------------------

  // Про получении фокуса выделяем весь текс
  $('#receipt-products .count input').focus( function() {
    var $this = $(this);
    $this.data('old-value', $this.val()).select();
  });

  // Количество товара - при потери фокуса сохраняем значение
  $('#receipt-products .count input').blur( function() {
    var $this = $(this);
    if ( parseFloat($this.data( 'old-value')) != parseFloat($this.val()) ) { $this.parent('form').submit(); };
  });

});