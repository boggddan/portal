$clmn = $( '#col_r' )
$blockTable = $clmn.children( '.parent_table' ).empty( )

<% if @receipts.present? %>
$blockTable.append '<%= j render( "table_receipts" ) %>'
MyLib.tableSetSession( $blockTable )
<% end %>
