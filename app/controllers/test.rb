# arr = [{id: 0, val: 'zero'}, {id: 1, val: 'one'}, {id: 2, val: 'two'}]
# arr.map!.with_index { | v, i |
#       next_v = arr[ arr.size == i + 1 ? 0 : i + 1 ];
#       v.merge!( { next_id: next_v[ :id ], next_val: next_v[ :val ] } ) }

# puts arr

# # {id:0, val:"zero", next_id:1, next_val:"one"}
# # {id:1, val:"one", next_id:2, next_val:"two"}
# # {id:2, val:"two", next_id:0, next_val:"zero"}
