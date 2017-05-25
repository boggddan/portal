# Фильтрация таблицы меню требования
$sessionKey = 'menu_requirements'
$sessionTableKey = "table_#{ $sessionKey }"
$tableName = "##{ $sessionTableKey }"

$( $tableName ).empty( ).append '<%= j render( "table_menu_requirements" ) %>'

$table = $( "#{$tableName} table" )

# Если существуют заявки по выбраному фильтру */
if $table.length
  $table.tableHeadFixer( )  # Фиксируем шапку таблицы
  $sortField = GetSession $sessionKey, 'sort_field'
  $sortOrder = GetSession $sessionKey, 'sort_order'
  $scroll = GetSession $sessionTableKey, 'scroll'
  $rowId = GetSession $sessionTableKey, 'row_id'

  ( $( "#{ $tableName } th##{ $sortField }" ).addClass "sort_#{ $sortOrder }" ) if $sortField
  ( $( $tableName ).scrollTop $scroll ) if $scroll
  ( $( "#{ $tableName } tbody tr[data-id='#{ $rowId } ']" ).addClass 'selected' ) if $rowId
else
  sessionStorage.removeItem $sessionTableKey