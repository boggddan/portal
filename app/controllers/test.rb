# require 'json'
# require 'awesome_print'
# require 'faker'

# # ts = JSON.parse( File.read( 'file_ts' ), symbolize_names: true )
# # td = JSON.parse( File.read( 'file_td' ), symbolize_names: true )

# # date = '2017-07-20'

# # child_ts = ts.select { | o | o[ :child_code ] == '3036374' and o[:date] == date }
# # child_td = td.select { | o | o[ :child_id ] == 14711 and o[:date] == date }

# # p child_ts, child_td


# # dd = [{one: 1},{one: 2}].map(& -> (item) { item[:one] == 1})

# count = 10


# users = []
# count.times do
#   users << [].tap do |user|
#     user << Faker::Name.first_name
#     user << Faker::Name.last_name
#     user << Faker::Internet.email
#     user << Faker::Address.street_address
#     user << Faker::Address.secondary_address
#     user << Faker::Address.city
#     user << Faker::Address.state_abbr
#     user << Faker::Address.zip_code.to_i
#   end
# end

# p users


