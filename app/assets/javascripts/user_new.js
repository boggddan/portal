$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#user_new' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_users' ).addClass( 'active' );

    // Тип пользователя
    changeUserableType = function () {
      var $radioValue = $( 'input[name="user[userable_type]"]:checked' ).val().toLowerCase();
      $( "[name='user[userable_id]']").prop( 'disabled', true );
      $( '#user_'+$radioValue ).prop( 'disabled', false );
      console.log($( '#user_'+$radioValue ));
    };


    $( "input[name='user[userable_type]'").change( function(){
      changeUserableType();
    });

    changeUserableType(); // Тип пользователя

  };
} );