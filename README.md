# address_verifier

address_verifier is a gem that uses the [Yaddress API](http://www.yaddress.net/Home/WebApi) to verify addresses and see if they are correct or not (as well as fix minor typos).

Creating address_verifier was an exercise in learning Ruby, as well as in using Web APIs and creating Gems. 

# API

The main method (`verify_address`) is located in the module **AddressVerifier**.  
`verify_address` takes 4 or 5 parameters (in the following order):
- **Street Address**: a String of the street address. (e.g. "137 Varick Street"). The suffix can be abbreviated (e.g. "dr", "st") or written in full (e.g. "drive", "street")
- **Secondary Designators**: a String of any secondary designators (e.g. "Apartment 7E"). If there are none, simply pass in an empty String. Once again, abbreviations are permitted (e.g. "apt" vs. "apartment")
- **City**: a String of the city. May be an empty String only if Zipcode is not empty.
- **State**: a String of the state. May be abbreviated (e.g. "NY", "HI") or not (e.g. "New York", "Hawaii"). May be an empty String only if Zipcode is not empty.
- **Zipcode**: a String of the zipcode. May be an empty String only if both State and City are not empty.
- **User Key**: a String of the UserKey. UserKeys must be purchased through [Yaddress](http://www.yaddress.net/Home/Pricing). May be the empty String or completely ommitted (in which case the module will act as if you passed in a blank UserKey).

Therefore the following code is valid:  
```sh
require 'address_verifier'
include AddressVerifier

AddressVerifier.verify_address "137 Varick Street", "", "NYC", "NY", ""  
AddressVerifier.verify_address "137 Varick St", "", "NYC", "NY", ""  
AddressVerifier.verify_address "137 Varick Street", "", "", "", "10013"  
AddressVerifier.verify_address "137 Varick St", "", "New York", "NY", ""  
AddressVerifier.verify_address "137 Varick Street", "", "New York", "New York", "10013"  
AddressVerifier.verify_address "137 Varick Street", "Suite 504", "NYC", "NY", ""   
AddressVerifier.verify_address "137 Varick Street", "Suite 504", "NYC", "NY", "", ""  
```

Calling `verify_address` returns a **YaddressReponse** object with the following methods:
- `verified?` returns true if the address passed in was legitimate (or close to a legitimate address with a few typos).
- `error_code` returns an int from 0 to 8 inclusive (which refer to [Yaddress' Error Codes](http://www.yaddress.net/Home/WebApi)). 0 refers to a verified address, 1-8 refer to some error (either a mis-typed address, invalid user key, or problems with Yaddress itself).
- `error_message` returns a more detailed message regarding the error. Usually something along the lines of "Invalid Address. Missing ____"
- `address_line_1` returns a String containing the Street Address and Secondary Designators of the verified address (or whatever was passed in if there is an error).
- `address_line_2` returns a String containing the City, State, and full Zipcode of the verified address (or whatever was passed in if there is an error).
- `latitude` returns a float refferring to the latitude of the location.
- `longitude` returns a float refferring to longitude of the location.

# Sample Code
```sh
require 'address_verifier'
include AddressVerifier

ad = AddressVerifier.verify_address "137 Varick Street", "Suite 504", "NYC", "NY", ""
puts ad.address_line_1
puts ad.address_line_2
puts ad.latitude
puts ad.longitude
puts ad.verified?
puts ad.error_code
puts ad.error_message

puts '**********'
ad2 = AddressVerifier.verify_address "999999999 Varick Street", "Suite 504", "NYC", "NY", ""
puts ad2.address_line_1
puts ad2.address_line_2
puts ad2.latitude
puts ad2.longitude
puts ad2.verified?
puts ad2.error_code
puts ad2.error_message
```

Which prints the following:
```sh
137 VARICK ST STE 504
NEW YORK, NY 10013-1105
40.725699
-74.005895
true

**********
999999999 VARICK STREET SUITE 504
NEW YORK, NY 10013
40.727131
-74.00543
false
8
No such house number in the street
```