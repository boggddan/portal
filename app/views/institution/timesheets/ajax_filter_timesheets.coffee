$clmn = $( '#col_t' )
$blockTable = $clmn.children( '.parent_table' ).empty( )

<% if @timesheets.present? %>
$blockTable.append '<%= j render( "table_timesheets" ) %>'
window.tableSetSession( $blockTable )
<% end %>