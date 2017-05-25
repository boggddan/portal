$( document ).on 'turbolinks:load', ->

  if $( '#report_base' ).length
    $parentElem = $( '#report_base' )

    $( '#main_menu li' ).removeClass 'active'
    $( '#mm_institution_reports' ).addClass 'active'

    #  Начальная дата фильтрации
    $( '#date_start' )
      .val( moment( ).startOf('month').format( $formatDate ) )
      .data( 'old-value', moment( ).startOf('month').format( $formatDate ) )
      .datepicker onSelect: ->
        $this = $( @ )
        $thisVal =  $this.val( )

        if $thisVal isnt $this.data 'old-value'
          $this.data 'old-value', $thisVal
          $dateEnd = $( '#date_end' )

          if moment( $thisVal, $formatDate ).isAfter( moment( $dateEnd.val( ), $formatDate ) )
            $dateEnd.val( $thisVal ).data 'old-value', $thisVal

    #  Конечная дата фильтрации
    $( '#date_end' )
      .val( moment( ).endOf('month').format( $formatDate ) )
      .data( 'old-value', moment( ).endOf('month').format( $formatDate ) )
      .datepicker onSelect: ->
        $this = $( @ )
        $thisVal =  $this.val( )

        if $thisVal isnt $this.data 'old-value'
          $this.data 'old-value', $thisVal
          $dateStart = $( '#date_start' )

          if moment( $thisVal, $formatDate ).isBefore( moment( $dateStart.val( ), $formatDate ) )
            $dateStart.val( $thisVal ).data 'old-value', $thisVal

    # Нажатие на кнопочку создать
    $( '.btn_create' ).click ->
      $( '#dialog_wait' ).dialog 'open'
      $dateStart = $( '#date_start' )
      $dateEnd = $( '#date_end' )

      $path = "#{ $parentElem.data( 'path-view' ) }?#{ $dateStart.attr 'id'  }=#{ $dateStart.val( ) }\
        &#{ $dateEnd.attr 'id' }=#{ $dateEnd.val( ) }"
      $.ajax url: $path, type: 'post', dataType: 'script'

    # Нажатие на кнопочку выход
    $( '.btn_exit' ).click ->
      window.location.replace $parentElem.data 'path-exit'
