$( document ).on('turbolinks:load', function() {

   //-------------------------------------------------------------
  // Нажатие на кнопочку удалить поступление
  $(document).on('click', '#users td .btn-del', function() {
    $(this).parents('tr').addClass("user-delete");
    $( "#user-delete-dialog" ).dialog( "open" );
  });
  //-------------------------------------------------------------

  //-------------------------------------------------------------
  // Диалог удаления поступления
  $( "#user-delete-dialog" ).dialog({
    autoOpen: false,
    resizable: false,
    height: "auto",
    width: 400,
    modal: true,
    buttons: {
      "Так": function() {
        $.ajax({ url: $('#users table tr.user-delete .btn-del').data('ajax-path'), type: 'DELETE', dataType: "script" });

        // Если один одна строка, тогда удаляем всю табличку
        if ( $('#users table tbody').children().length == 1 ) {
          $('#users table').remove();
        } else {
          $('#users table tr.user-delete').remove();
        } ;
        $(this).dialog( "close" );
      },
      "Hі": function() { $(this).dialog( "close" );
      }
    }
  });
  //-------------------------------------------------------------

});