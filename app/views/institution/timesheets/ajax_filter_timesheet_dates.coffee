#  Фильтрация таблицы содержимого документа табеля
$( '#table_timesheet_dates' ).empty( ).append( '<%= j render( "institution/timesheets/table_timesheet_dates" ) %>' )

$table = $( '#table_timesheet_dates table' )

if $table.length
  $table.tableHeadFixer 'left': 3 # Фиксируем шапку таблицы
  $dateSaVal = $( '#date_sa' ).val( )

  # Ширину таблицы вычесляем Первая колонка 250, все остальные 60
  $tableWidth =  250 + ($table.find( 'col' ).length - 1) * 60
  $table.width( $tableWidth )
  $tableParentWidth = $tableWidth + getScrollbarWidth( )
  $table.parent( ).width( $tableParentWidth ) if $table.parent( ).width( ) > $tableParentWidth

  sumAll = ->
    $( '#table_timesheet_dates .cell_day' ).each( -> # Очистка все итогов
      $( @ ).html( '' )
      $( @ ).data( 'absence', '' )
    )

    $( '#table_timesheet_dates tr.row_data' ).each( -> # По всем строкам с данными
      $tr = $( @ )

      $sum = [ 0, 0 ]

      $categoryId = $tr.data 'category-id'
      $groupId = $tr.data 'group-id'
      $childId = $tr.data 'child-id'

      $tr.children( '.cell_mark:not( [ disabled ] )' ).each( ( ) ->
        $cell = $( @ );
        $elem = $( "#group_#{ $categoryId }_#{ $groupId }_#{ $cell.data 'date-id' }" )

        if $cell.html( )
          $sum[ 1 ] += 1
          $elem.data( 'absence', Number( $elem.data( 'absence' ) ) + 1 )
        else
          $sum[ 0 ] += 1
          $elem.html( Number( $elem.html( ) ) + 1 )
      )
      [ 'appearance', 'absence' ].forEach ( v, i ) ->
        $tr.children( "#child_#{ $categoryId }_#{ $groupId }_#{ $childId }_#{ v }" ).html( $sum[ i ] || '' )
    )

    $( "#table_timesheet_dates tr.group" ).each( -> # По всем строкам групп
      $tr = $( @ )

      $sum = [ 0, 0 ]
      $categoryId = $tr.data 'category-id'
      $groupId = $tr.data 'group-id'

      $tr.children( '.cell_day' ).each( ( $tdIndex ) ->
        $cell = $( @ );
        $sumAppearance = Number( $cell.html( ) )
        $sumAbsence = Number( $cell.data( 'absence' ) )

        $sum[ 0 ] += $sumAppearance
        $sum[ 1 ] += $sumAbsence

        $elem = $( "#category_#{ $categoryId }_#{ $tdIndex }" )

        $elem.html( Number( $elem.html( ) ) + $sumAppearance ) if $sumAppearance
        $elem.data( 'absence', Number( $elem.data( 'absence' ) ) + $sumAbsence ) if $sumAbsence
      )

      [ 'appearance', 'absence' ].forEach ( v, i ) ->
        $tr.children( "#group_#{ $categoryId }_#{ $groupId }_#{ v }" ).html( $sum[ i ] || '' )
    )

    $( "#table_timesheet_dates tr.category" ).each( -> # По всем строкам с категорий
      $tr = $( @ )

      $sum = [ 0, 0 ]
      $categoryId = $tr.data 'category-id'

      $tr.children( '.cell_day' ).each( ( $cellIndex ) ->
        $cell = $( @ );
        $sumAppearance = Number( $cell.html( ) )
        $sumAbsence = Number( $cell.data( 'absence' ) )

        $sum[ 0 ] += $sumAppearance
        $sum[ 1 ] += $sumAbsence

        $elem = $( "#all_#{ $cellIndex }" )
        $elem.html( Number( $elem.html( ) ) + $sumAppearance ) if $sumAppearance
        $elem.data( 'absence', Number( $elem.data( 'absence' ) ) + $sumAbsence ) if $sumAbsence
      )

      [ 'appearance', 'absence' ].forEach ( v, i ) ->
        $tr.children( "#category_#{ $categoryId }_#{ v }" ).html( $sum[ i ] || '' )
    )

    $( "#table_timesheet_dates tr.all" ).each( -> # По всем строкам с категорий
      $tr = $( @ )

      $sum = [ 0, 0 ]

      $tr.children( '.cell_day' ).each( ( $cellIndex ) ->
        $cell = $( @ );

        $sum[ 0 ] += Number( $cell.html( ) )
        $sum[ 1 ] += Number( $cell.data( 'absence' ) )
      )

      [ 'appearance', 'absence' ].forEach ( v, i ) ->
        $tr.children( "#all_#{ v }" ).html( $sum[ i ] || '' )
    )

  sumAll( )

  # Обновление маркера
  timesheetDatesUpdate = ( $timesheetDatesId, $reasonsAbsenceId ) ->
    $path = "#{ $( '#timesheet_dates' ).data 'path-update-dates' }?id=#{ $timesheetDatesId }\
      &reasons_absence_id=#{ $reasonsAbsenceId }"
    $.ajax url: $path, type: 'post', dataType: 'script'

  # Нажати на ячейку
  $( 'td.cell_mark' )
    .click ->
      $this = $( @ )
      unless $dateSaVal or $this.attr 'disabled'
        $reasonsAbsence = $( "#reasons_absences li[data-id='#{ $this.data( 'reasons-absence-id' ) }']" )
        $reasonsAbsenceId = $reasonsAbsence.data 'next-id'
        $this.data 'reasons-absence-id', $reasonsAbsenceId
        $this.html( $reasonsAbsence.data 'next-val' )
        timesheetDatesUpdate( $this.data( 'id' ), $reasonsAbsenceId ) # Обновление маркера
        sumAll( )

    .contextmenu ( event ) ->
      event.preventDefault( );
      $this = $( @ )
      unless $dateSaVal or $this.attr 'disabled'
        $reasonsAbsence = $( '#reasons_absences li:first-child' )
        $reasonsAbsenceId = $reasonsAbsence.data 'id'
        $this.data 'reasons-absence-id', $reasonsAbsenceId
        $this.html $reasonsAbsence.html( )
        timesheetDatesUpdate( $this.data( 'id' ), $reasonsAbsenceId ) # Обновление маркера
        sumAll( )

  # Нажати на ячейку
  $( 'tr.row_data' )
    .click ->
      $this = $( @ )
      $this.addClass( 'selected' ).siblings( ).removeClass 'selected'