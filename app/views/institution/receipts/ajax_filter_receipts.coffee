$clmn = $( '#col_r' )
$blockTable = $clmn.children( '.parent_table' ).empty( )

<% if @receipts.present? %>
$blockTable.append '<%= j render( "table_receipts" ) %>'
window.tableSetSession( $blockTable )
<% end %>