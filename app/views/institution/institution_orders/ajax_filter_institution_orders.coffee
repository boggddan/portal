# Фильтрация таблицы заявок
$blockTable = $( '#col_io .parent_table' ).empty( )

$disabled = false
<% if @institution_orders.present? %>
$blockTable.append '<%= j render( "table_institution_orders" ) %>'
MyLib.tableSetSession( $blockTable )
$disabled = true
<% end %>

$( '#col_io .btn_create' ).prop 'disabled', $disabled