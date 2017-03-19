$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#institution_reports' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_institution_reports' ).addClass( 'active' );
  };
});