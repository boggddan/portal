# Фильтрация таблицы заявок

$clmn = $( '#col_ioc' )
$blockTable = $clmn.children( '.parent_table' ).empty( )

$id = ''
$number = ''
$disabled = true

<% if @institution_order.present? %>
$id = '<%= @institution_order.id %> '
$number = '<%= @institution_order.number %>'
$disabled = not '<%= @institution_order.number_sa %>'

<% if @io_corrections.present? %>
$blockTable.append( '<%= j render( "table_corrections" ) %>' )
window.tableSetSession( $blockTable )
$disabled = not '<%= @io_corrections.last.number_sa %>'
<% end %>

<% end %>

$clmn
  .data( institution_order_id: $id )
  .children( 'h1' ).text( "#{ $clmn.data 'captions' } #{ $number }" )
  .end( )
  .find( '.btn_create' ).prop 'disabled', $disabled