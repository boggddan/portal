$( document ).on 'turbolinks:load', ->

  # Если объект существует
  $timesheets = $( '#timesheets' )

  if $timesheets.length
    $parentElem = $timesheets

    $sessionKey = $parentElem.attr 'id'
    $sessionTableKey = "table_#{ $sessionKey }"

    $( "#mm_#{ $sessionKey }" ).addClass( 'active' ).siblings( ).removeClass 'active'

    # Фильтрация таблицы документов
    filterTable = ->
      $data =
        'date_start': GetSession $sessionKey, 'date_start'
        'date_end': GetSession $sessionKey, 'date_end'
        'sort_field': GetSession $sessionKey, 'sort_field'
        'sort_order': GetSession $sessionKey, 'sort_order'

      $.ajax { url: $parentElem.data( 'path-filter' ), type: 'get', data: $data, dataType: 'script' }

    filterTable( ) # Фильтрация таблицы документов

    $( '#dialog_delete' )
      .on 'delete', ->  # Удаление меню-требования
        $path = "#{ $parentElem.data( 'path-del' ) }?id=#{ $( 'tr.delete' ).data 'id' }"
        $.ajax url: $path, type: 'delete', dataType: 'script'
        # Если один одна строка, тогда удаляем всю табличку
        if $( 'tbody' ).children( ).length is 1 then $( 'table' ).remove( ) else $( 'tr.delete' ).remove( )
      .on 'un_delete', -> $( 'tr.delete' ).removeClass 'delete' # Отмена удаления меню-требования

    # Нажатие на кнопочку создать
    $( '.btn_create' ).click ->
      $( '#dialog_wait' ).dialog 'open'
      window.location.replace $parentElem.data 'path-new'

    #  Конечная дата фильтрации
    $( '#date_start' )
      .val GetSession $sessionKey, 'date_start'
      .data 'old-value', GetSession $sessionKey, 'date_start'
      .datepicker onSelect: ->
        $this = $( @ )
        $thisVal =  $this.val( )

        if $thisVal isnt $this.data 'old-value'
          SetSession $sessionKey, 'date_start', $thisVal
          $this.data 'old-value', $thisVal
          $dateEnd = $( '#date_end' )
          $dateEndVal = $dateEnd.val( )

          if not $dateEndVal || moment( $thisVal, $formatDate ).isAfter( moment( $dateEndVal, $formatDate ) )
            SetSession $sessionKey, 'date_end', $thisVal
            $dateEnd.val( $thisVal ).data 'old-value', $thisVal

          filterTable( ) # Фильтрация таблицы документов

    #  Конечная дата фильтрации
    $( '#date_end' )
      .val GetSession $sessionKey, 'date_end'
      .data 'old-value', GetSession $sessionKey, 'date_end'
      .datepicker onSelect: ->
        $this = $( @ )
        $thisVal =  $this.val( )

        if $thisVal isnt $this.data 'old-value'
          SetSession $sessionKey, 'date_end', $thisVal
          $this.data 'old-value', $thisVal
          $dateStart = $( '#date_start' )
          $dateStartVal = $dateStart.val( )

          if not $dateStartVal || moment( $thisVal, $formatDate ).isBefore( moment( $dateStartVal, $formatDate ) )
            SetSession $sessionKey, 'date_start', $thisVal
            $dateStart.val( $thisVal ).data 'old-value', $thisVal

          filterTable( ) # Фильтрация таблицы документов

    # Нажатие на кнопочку в табичке
    $( document ).on 'click', 'td .btn_del, td .btn_view, td .btn_edit', ->
      $this = $( @ )
      $tr = $this.closest( 'tr' )

      if $this.hasClass 'btn_del' # удалить
        $tr.addClass 'delete'
        $( '#dialog_delete' ).dialog 'open'
      else # для перехода в табличную часть
        $trId = $this.parents( 'tr' ).data 'id'
        SetSession $sessionTableKey, 'scroll', $( "##{ $sessionTableKey }" ).scrollTop( )
        SetSession $sessionTableKey, 'row_id', $trId
        window.location.replace "#{ $parentElem.data 'path-view' }?id=#{ $trId }"

    # Нажатие для сортировки
    $( document ).on 'click', 'th[id]', ->
      $this = $( @ )
      $class = add: 'sort_desc', remove: 'sort_asc'

      [ $class.add, $class.remove ] = [ 'sort_asc', 'sort_desc' ] if $this.hasClass 'sort_desc'

      $this.removeClass( $class.remove ).addClass( $class.add )

      SetSession $sessionKey, 'sort_field', $this.attr( 'id' )
      SetSession $sessionKey, 'sort_order', $class.add.split( '_' )[ 1 ]
      filterTable( ) # Фильтрация таблицы документов
