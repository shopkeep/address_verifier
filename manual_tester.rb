require_relative "address_verifier"

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

av =  AddressVerifier.verify_address street_address, secondary_designators, city, state, zip
puts av.json