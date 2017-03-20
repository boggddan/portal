$( document ).on( 'turbolinks:load', function() {

  // Если объект существует
  if ( $( '#users' ).length ) {
    $( '#main_menu li' ).removeClass( 'active' );
    $( '#mm_users' ).addClass( 'active' );

    $( '#dialog_delete' ).data( 'delete', 'deleteUser();' ); // Функция для удаления пользователя
    $( '#dialog_delete' ).data( 'un-delete', 'unDeleteUser();' ); // Отмена удаления пользователя

    $( '.table' ).tableHeadFixer(); // Фиксируем шапку таблицы

    // Удаление пользователя
    deleteUser = function () {
      var $path_ajax = $( '.table' ).data( 'path-del' ) + $( 'tr.delete' ).data( 'id' );
      $.ajax( { url: $path_ajax, type: 'DELETE', dataType: 'script' } );

      // Если один одна строка, тогда удаляем всю табличку
      if ($( 'tbody' ).children().length == 1 ) { $( '#table_users' ).empty() }
        else { $( 'tr.delete' ).remove() }
    } };

    // Отмена удаления заявки
    unDeleteUser = function() { $( 'tr.delete' ).removeClass( 'delete' ) };

    // Нажатие на кнопочку удалить поступление
    $( document ).on( 'click', 'td .btn_del', function() {
      $( this ).parents( 'tr' ).addClass( 'delete' );
      $( '#dialog_delete' ).dialog( 'open' );
    } );

    // Нажатие на кнопочку для перехода заполнения информации
    $( document ).on( 'click', 'td .btn_view, td .btn_edit', function() {
      window.location.replace( $( this ).parents( 'table' )
          .data( 'path-view' ) + $( this ).parents( 'tr' ).data( 'id' ) );
    } );

} );
