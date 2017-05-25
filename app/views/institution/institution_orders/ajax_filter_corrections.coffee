# Фильтрация таблицы заявок

$clmn = $( '#col_ioc' )
$blockTable = $clmn.children( '.parent_table' ).empty( )

$io_id = ''
$io_number = ''
$disabled = true

<% if @institution_order.present? %>
$io_id = '<%= @institution_order.id %> '
$io_number = '<%= @institution_order.number %>'
$disabled = not '<%= @institution_order.number_sa %>'

<% if @io_corrections.present? %>
$blockTable.append( '<%= j render( "table_corrections" ) %>' )
window.tableSetSession( $blockTable )
$disabled = not '<%= @io_corrections.last.number_sa %>'
<% end %>

<% end %>

$clmn
  .data( institution_order_id: $io_id )
  .children( 'h1' ).text( "#{ $clmn.data 'captions' } #{ $io_number }" )
  .end( )
  .find( '.btn_create' ).prop 'disabled', $disabled