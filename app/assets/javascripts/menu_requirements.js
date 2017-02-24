$( document ).on('turbolinks:load', function() {

  // Если объект существует
  if ( $('#menu_requirements').length ) {
    $('#main_menu li').removeClass('active');
    $('#mm_menu_requirements').addClass('active');

    if (sessionStorage.menu_requirements_date_start) { $('#date_start').val(sessionStorage.menu_requirements_date_start) };
    if (sessionStorage.menu_requirements_date_end) { $('#date_end').val(sessionStorage.menu_requirements_date_end) };

    filterTableMenuRequirements(); // Фильтрация таблицы меню-требований

    $("#dialog_delete").data('delete','deleteMenuRequirement();'); // Функция для удаления меню-требования
    $("#dialog_delete").data('un-delete','unDeleteMenuRequirement();'); // Отмена удаления меню-требования

    // Фильтрация таблицы меню-требований
    function filterTableMenuRequirements() {
      var $date_start = $('#date_start');
      var $date_end = $('#date_end');
      var $date_start_val = $date_start.val();
      var $date_end_val = $date_end.val();

      sessionStorage.menu_requirements_date_start = $date_start_val;
      sessionStorage.menu_requirements_date_end = $date_end_val;

      var $path_ajax = $date_start.data('ajax-path')+'?'+$date_start.attr('name')+'='+$date_start_val+'&'+$date_end.attr('name')+'='+$date_end_val;
      $.ajax( { url: $path_ajax, type: 'GET', dataType: "script" } );
    };

    // Удаление меню-требования
    deleteMenuRequirement = function() {
      $.ajax({ url: $('tr.delete .btn_del').data('ajax-path'), type: 'DELETE', dataType: "script" });

      // Если один одна строка, тогда удаляем всю табличку
      if ( $('tbody').children().length == 1 ) { $('#table_menu_requirements').empty(); } else { $('tr.delete').remove(); } ;
    };

    // Отмена удаления меню-требования
    unDeleteMenuRequirement = function() {
      $('tr.delete').removeClass("delete");
    };

    // Нажатие на кнопочку создать
    $('#create_menu').click( function() {
      $( "#dialog_wait" ).dialog( "open" );
      $.ajax({ url: $(this).data('ajax-path'), type: 'POST', dataType: "script" });
    });

    // Начальная дата фильтрации
    $('#date_start').datepicker({
      onSelect: function() {
        var $thisVal = $(this).val();
        var $date_end = $('#date_end');
        if ( $thisVal > $date_end.val() ) { $date_end.val($thisVal); };
        filterTableMenuRequirements(); // Фильтрация таблицы меню-требований
      }
    });

    // Конечная дата фильтрации
    $('#date_end').datepicker({
      onSelect: function() {
        var $thisVal = $(this).val();
        var $date_start = $('#date_start');
        if ( $thisVal < $date_start.val() ) { $date_start.val($thisVal); };
        filterTableMenuRequirements(); // Фильтрация таблицы меню-требований
      }
    });

    // Нажатие на кнопочку удалить поступление
    $(document).on('click', 'td .btn_del', function() {
      $(this).parents('tr').addClass("delete");
      $("#dialog_delete" ).dialog( "open" );
    });

    // Нажатие на кнопочку для перехода заполнения информации
    $(document).on('click', 'td .btn_view, td .btn_edit', function() {
      var $tr = $(this).parents('tr');
      sessionStorage.menu_requirements_table_row = $tr.index()+1;
      sessionStorage.menu_requirements_table_scroll = $('#table_menu_requirements').scrollTop();
      window.location.replace($tr.data('path'));
    });

  };
});