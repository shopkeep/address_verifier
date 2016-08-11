require_relative "lib/address_verifier"

include AddressVerifier

puts "Street Address? (Required)"
street_address = gets.chomp
puts "Secondary Designators? (Optional)"
secondary_designators = gets.chomp
puts "City? (Either City+State or Zipcode is required)"
city = gets.chomp
puts "State? (Either City+State or Zipcode is required)"
state = gets.chomp
puts "Zipcode? (Either City+State or Zipcode is required)"
zip = gets.chomp

address = AddressVerifier.verify_address street_address, secondary_designators, city, state, zip
puts "Line1: #{address.address_line_1}"
puts "Line2: #{address.address_line_2}"
puts "ErrorCode: #{address.error_code}"
puts "ErrorMessage: #{address.error_message}"