# Фильтрация таблицы заявок
$blockTable = $( '#col_so .parent_table' ).empty( )

<% if @supplier_orders.present? %>
$blockTable.append '<%= j render( "table_supplier_orders" ) %>'
window.tableSetSession( $blockTable )
<% end %>