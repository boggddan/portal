$clmn = $( '#col_r' )
$contract_number = $clmn.find( '#contract_number' ).empty( ).append( "<option value=''>Договір</option>" )

$id = ''
$number = ''
$contractVal = ''
$disabled = true

<% if @supplier_order.present? %>
$id = '<%= @supplier_order.id %> '
$number = '<%= @supplier_order.number %>'

<% if @contracts.present? %>
$contract_number.append('<%= options_from_collection_for_select( @contracts, :contract_number, :contract_number ) %>')

$sessionKey = $clmn.closest( 'main' ).attr( 'id' )
$contractVal = MyLib.getSession( $sessionKey )[ $contract_number.attr('id') ]
$contract_number.val( $contractVal ) if $contractVal
$disabled = false
<% end %>

<% end %>

window.receiptsSelectCountact( )

$clmn
  .data( supplier_order_id: $id )
  .children( 'h1' ).text( "#{ $clmn.data 'captions' } #{ $number }" )

$contract_number.prop( 'disabled', $disabled )