isObject = (item) -> # Проверка на соотвествие типа, является ли объетом
  item and typeof item is 'object' and not Array.isArray item

mergeDeep = (target, source) -> # Соеднинение двох объектов с мержирование ключей
  if isObject(target) and isObject(source)
    Object.keys(source).forEach (key) ->
      if isObject source[ key ]
        if not target[key] then Object.assign target, { "#{key}": {} }
        mergeDeep target[ key ], source[ key ]
      else
        Object.assign target, { "#{key}": source[key] }

  target

# window.toDecimal111 = ( $value, $scale = -1 ) ->
#   switch typeof( $value )
#     when 'number' then $returnVal = $value
#     when 'string'
#       $returnVal = parseFloat( $value.toString().replace(',','.').replace(/\s+/g,'') )
#       $returnVal = 0 if isNaN( $returnVal )
#     else $returnVal = 0
#
#   if $scale isnt -1
#     $scaleVal = Math.pow( 10, $scale )
#     $returnVal = Math.trunc( $returnVal * $scaleVal ) / $scaleVal
#   $returnVal
#
# window.floatToString111 = ( $value, $scale = 0 ) ->
#   if $value
#     if $scale
#       $scaleVal = Math.pow( 10, $scale )
#       $returnVal = ( Math.trunc( $value * $scaleVal ) / $scaleVal ).toFixed( $scale )
#     else
#       $returnVal = $value
#   else
#     $returnVal = ''

window.setSession = ( $key, $value ) -> # Запись в сессию
  $sessionObj = JSON.parse( sessionStorage.getItem( $key ) ) || { } # спарсим объект обратно
  mergeDeep( $sessionObj, $value ) # Обьединие масивов
  sessionStorage.setItem( $key, JSON.stringify( $sessionObj ) )

window.setClearTableSession = ( $key, $keyTable ) -> # Запись в сессию
  $sessionObj = JSON.parse( sessionStorage.getItem( $key ) ) || { } # спарсим объект обратно
  if $sessionObj[ $keyTable ]
    delete $sessionObj[ $keyTable ].row_id
    delete $sessionObj[ $keyTable ].scroll_top
    sessionStorage.setItem( $key, JSON.stringify( $sessionObj ) )

window.setDeleteElemSession = ( $key, $elem ) -> # Запись в сессию
  $sessionObj = JSON.parse( sessionStorage.getItem( $key ) ) || { } # спарсим объект обратно
  if $sessionObj
    delete $sessionObj[ $elem ]
    sessionStorage.setItem( $key, JSON.stringify( $sessionObj ) )

window.getSession = ( $key ) -> # Чтение из сессии
  $sessionObj = JSON.parse( sessionStorage.getItem( $key ) ) || { } #

window.getSessionKey = ( $this ) -> $this.closest( 'main' ).attr 'id'
window.getSessionClmnKey = ( $this ) -> $this.closest( '.clmn' ).attr 'id'
################################

window.pageLoader = ( $show ) ->
  if $show is true then $( '.preloader' ).addClass 'show' else $( '.preloader' ).removeClass 'show'

window.capitalize = ( $str ) -> "#{ $str.charAt( 0 ).toUpperCase( ) }#{ $str.slice( 1 ) }"

window.assignLocation = ( siteUrl, urlParams = {} ) ->
  pageLoader true

  serializeParams = (params) ->
    Object.keys(urlParams).reduce((acc, cur) ->
      acc += "&#{ cur }=#{ encodeURIComponent( urlParams[cur] ) }"
    , '').replace(/^&/, '?')

  window.location.assign "#{ siteUrl }#{ serializeParams( urlParams ) }"

window.ajax = ( $caption, $url, $type, $data, $dataType, $urlAssing, $success, $loader = true ) ->
  pageLoader $loader

  $.ajax(
    url: $url
    type: $type
    data: $data
    dataType: $dataType
    success: ( data ) ->
      if $dataType is 'json'
        if data.status is true
          assignLocation $urlAssing, data.urlParams if $urlAssing
          $href = data.href
          $view = data.view
          ( if $href.search(/.pdf$/i) is -1 then assignLocation( $href ) else window.open( $href ) ) if $href
          ( $('#view').html( $view ) ) if $view
          $success( ) if $success
          pageLoader false if $loader
        else
          errorMsg data.caption || $caption, JSON.stringify( data.message, null, ' ' )
      else
        pageLoader false if $loader

    error: ( xhr ) ->  errorMsg $caption, xhr.responseText
  )

window.errorMsg = ( $header = '', $message = '' ) -> # Сообщение об ошибке
  pageLoader false
  $( '#error_msg' )
    .removeClass 'hide'
    .find( '.caption' ).text $header
    .end( )
    .find( '.text' ).text $message

window.delMsg = ( $header, $func ) -> # Сообщение об ошибке
  $( '#del_msg' )
    .removeClass 'hide'
    .find( '.caption' ).text $header
    .end( )
    .find( '.success' ).one 'click', ->
      $('#del_msg').addClass 'hide'
      $func( )

window.createDoc = ( $elem, $data ) -> # Нажатие на кнопочку создать
  $elem = $( $elem ) unless $elem instanceof $
  $dataAttr = $( $elem ).closest( '.clmn' ).data( )
  console.log($dataAttr.pathCreate)
  window.ajax(
    "Сторення: #{ $dataAttr.caption } "
    $dataAttr.pathCreate
    'post'
    $data
    'json'
    $dataAttr.pathView )

window.selectDateStart = ( $this, $dateEndId, $func ) -> # Начальная дата фильтрации
  $this = $( $this ) unless $this instanceof $
  $sessionKey = $this.closest( 'main' ).attr( 'id' )
  $thisVal =  $this.val( )

  if $thisVal isnt $this.data 'old-value'
    $sessionKey = getSessionKey $this
    setSession $sessionKey, { date_start: $thisVal }
    $this.data 'old-value', $thisVal
    $dateEnd = $( $dateEndId )
    $dateEndVal = $dateEnd.val( )

    if not $dateEndVal || moment( $thisVal, $formatDate ).isAfter( moment( $dateEndVal, $formatDate ) )
      setSession $sessionKey, { date_end: $thisVal }
      $dateEnd.val( $thisVal ).data 'old-value', $thisVal
    $func( ) if $func

window.selectDateEnd = ( $this, $dateStartId, $func ) -> # Конечная дата фильтрации
  $this = $( $this ) unless $this instanceof $
  $thisVal =  $this.val( )

  if $thisVal isnt $this.data 'old-value'
    $sessionKey = getSessionKey $this
    setSession $sessionKey, { date_end: $thisVal }
    $this.data 'old-value', $thisVal
    $dateStart = $( $dateStartId )
    $dateStartVal = $dateStart.val( )

    if not $dateStartVal || moment( $thisVal, $formatDate ).isBefore( moment( $dateStartVal, $formatDate ) )
      setSession $sessionKey, { date_start: $thisVal }
      $dateStart.val( $thisVal ).data 'old-value', $thisVal
    $func( ) if $func

window.rowSelect = ( $tr, $func ) -> # Нажатие на строку в табичке
  $tr = $( $tr ) unless $tr instanceof $
  $tr.addClass( 'selected' ).siblings().removeClass 'selected'
  setSession(
    getSessionKey( $tr )
    "#{ getSessionClmnKey $tr }": { row_id: $tr.data 'id'} )
  $func( ) if $func

window.tableButtonClick = ( $button, $funcDel ) -> # Нажатие на кнопочку в табичке
  $button = $( $button ) unless $button instanceof $
  $clmn = $( $button ).closest( '.clmn' )
  $dataAttr =  $clmn.data( )
  $table = $button.closest 'table'

  $tr = $button.closest 'tr'
  $trId = $tr.data 'id'

  if $table.data( 'type' ) is 'list_doc'
    $msgDelCaption = "#{ $dataAttr.caption } \
      № #{ $tr.children( 'td[data-field=number]' ).text( ) } \
      від #{ $tr.children( 'td[data-field=date]' ).text( ) }"

  switch
    when $button.hasClass 'btn_del' # удалить

      delMsg(
        $msgDelCaption
        ( ) ->
          ajax(
            "Видалення: #{ $msgDelCaption } [id: #{ $trId }]"
            $dataAttr.pathDel
            'delete'
            { id: $trId, bug: '' }
            'json'
            ''
            ( ) ->
              if $table.find( 'tbody tr' ).length is 1 then $table.remove( ) else $tr.remove( )
              setClearTableSession( getSessionKey( $clmn ), $clmn.attr 'id' )
              $funcDel( ) if $funcDel
            true
          )
      )

    when $button.hasClass( 'btn_view' ) || $button.hasClass( 'btn_edit' ) # для перехода в табличную часть
      assignLocation $dataAttr.pathView, id: $trId

window.tableHeaderClick = ( $th, $func ) -> # Нажатие для сортировки
  $th = $( $th ) unless $th instanceof $
  $class = add: 'desc', remove: 'asc'

  [ $class.add, $class.remove ] = [ $class.remove,  $class.add ] if $th.hasClass $class.add
  $th.removeClass( $class.remove ).addClass( $class.add )

  setSession(
    getSessionKey $th
      { "#{ getSessionClmnKey $th }": { sort_field:  $th.data( 'sort' ), sort_order: $class.add } } )
  $func( ) # Фильтрация таблицы документов

window.tableSetSession = ( $blockTable ) ->
  $blockTable = $( $blockTable ) unless $blockTable instanceof $
  $sesionKey = getSessionKey $blockTable
  $clmn =  $( $blockTable ).closest( '.clmn' )
  $clmnKey = $clmn.attr 'id'
  $sessionObj = getSession( $sesionKey )[ $clmnKey ]
  $blockTable
    .children( 'table' ).tableHeadFixer( )  # Фиксируем шапку таблицы
    .end( )
    .scroll ( ) ->  setSession( $sesionKey, { "#{ $clmnKey }": { scroll_top: $( @ ).scrollTop( ) } } )

  if $sessionObj
    $blockTable.find( "th[data-sort=#{ $sessionObj.sort_field }]").addClass( $sessionObj.sort_order ) if $sessionObj.sort_field
    $blockTable.scrollTop( $sessionObj.scroll_top ) if $sessionObj.scroll_top
    if $sessionObj.row_id
      $row = $blockTable.find( "tr[data-id=#{ $sessionObj.row_id } ]" )
      if $row then $row.addClass 'selected'  else setSession $sesionKey, { "#{ $clmnKey }": { row_id: 0 } }

window.clickHeader = ( $elem ) ->
  $elem = $( $elem ) unless $elem instanceof $
  $elem.toggleClass 'hide'
  $( '.panel_main' ).toggleClass 'hide'

window.сhangeValue = ( $elem, $parentName, $func ) -> # Изминение значение таблице и на панели
  $elem = $( $elem ) unless $elem instanceof $
  $name = $elem.attr 'name'
  $dataType = $elem.data( 'type' )

  if $dataType?.charAt(0) is 'n'
    $scale = +$dataType.slice(1) or -1
    $val = toDecimal( $elem.val( ), $scale )
    $valOld =  +$elem.data 'old-value'
    $strVal = floatToString( $val )
    console.log($val, $scale, $elem.val( ), $strVal )
    $elem.val( $strVal ).attr 'value', $strVal
  else
    $val = $elem.val( )
    $valOld =  $elem.data 'old-value'

  switch $parentName
    when 'tr'
      $parentElem = $elem.closest( '.clmn' )
      $id = $elem.closest( $parentName ).data 'id'
    when 'main'
      $parentElem = $elem.closest( 'main' )
      $id = $parentElem.data 'id'
    else
      $id = -1

  if $val isnt $valOld
    $elem.data( 'old-value', $val )
    ajax(
      "Зміна значення #{ $name } з #{ $valOld } на #{ $val } [id: #{ $id }]"
      $parentElem.data( 'path-update' )
      'post',
      { id: $id, "#{ $name }": $val }
      'json',
      '',
      $func,
      false ) if $id isnt -1

window.initValue = ( $elem ) ->
  $elem = $( $elem ) unless $elem instanceof $
  $tagName = $elem.prop( 'tagName' )
  $dataType = $elem.data( 'type' )

  $elemVal = if $tagName is 'INPUT' then $elem.val( ) else $elem.text( )

  if $dataType?.charAt( 0 ) is 'n'
    $scale = +$dataType.slice(1) or -1
    $val = toDecimal( $elemVal, $scale )
    $valFmt = floatToString( $val )
    if $tagName is 'INPUT' then $elem.val( $valFmt ) else $elem.text( $valFmt )
  else
    $val = $elemVal

  $elem.data( 'old-value', $val )

window.btnSendClick = ( $elem ) ->
  $elem = $( $elem ) unless $elem instanceof $

  pageLoader true
  $main = $elem.closest( 'main' )
  $id = $main.data 'id'

  ajax(
    "Відправка данних в 1С [id: #{ $id }]"
    $main.data( 'path-send' )
    'post'
       id:  $id, bug: ''
    'json'
    false
    ( ) -> window.location.reload( )
    true )

window.btnPrintClick = ( $elem ) ->
  $elem = $( $elem ) unless $elem instanceof $
  pageLoader true
  $main = $elem.closest( 'main' )
  $id = $main.data 'id'

  ajax(
    "Формування звіта в 1С [id: #{ $id }]"
    $main.data( 'path-print' )
    'post'
       id: $id, bug: ''
    'json'
    false
    false
    true )

window.btnExitClick = ( $elem ) -> # Нажатие на кнопочку выход
  $elem = $( $elem ) unless $elem instanceof $
  pageLoader true
  window.location.replace $elem.closest( 'main' ).data 'path-exit'

#####################

$( document ).on 'turbolinks:load', ( ) ->
  $( '#error_msg .close' ).click -> $( '#error_msg' ).addClass 'hide'

  $( '#del_msg button:not( success )' ).click -> $( '#del_msg' ).addClass( 'hide' ).find( '.success' ).off 'click'
