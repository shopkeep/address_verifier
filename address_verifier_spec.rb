require_relative "address_verifier.rb"

include AddressVerifier

describe AddressVerifier do

	describe ".verify_address" do

		context "given a verifiable address" do
			before(:each) do
				stub_request(:get, "http://www.yaddress.net/api/Address?AddressLine1=46%20Dogwood%20Drive&AddressLine2=Plainsboro%20New%20Jersey%2008536&UserKey=").
				with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => 
              '{
                  "ErrorCode": 0,
                  "ErrorMessage": "",
                   "AddressLine1": "46 DOGWOOD DR",
                   "AddressLine2": "PLAINSBORO, NJ 08536-1963",
                   "Number": "46",
                   "PreDir": "",
                   "Street": "DOGWOOD",
                   "Suffix": "DR",
                   "PostDir": "",
                   "Sec": "",
                   "SecNumber": "",
                   "City": "PLAINSBORO",
                   "State": "NJ",
                   "Zip": "08536",
                   "Zip4": "1963",
                   "County": "MIDDLESEX",
                   "StateFP": "34",
                   "CountyFP": "023",
                   "CensusTract": "86.01",
                   "CensusBlock": "2070",
                   "Latitude": 40.328282,
                   "Longitude": -74.611678,
                   "GeoPrecision": 5
                 }',
                 :headers => {})
			end

			it "returns a verified address" do
				address = AddressVerifier.verify_address "46 Dogwood Drive", "", "Plainsboro", "New Jersey", "08536"
				expect(address.verified?).to eq(true)
			end



		end
		context "given an unverifiable address" do
			before(:each) do
        stub_request(:get, "http://www.yaddress.net/api/Address?AddressLine1=5000%20Dogwood%20Drive&AddressLine2=Plainsboro%20New%20Jersey%2008536&UserKey=").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => 
              '{
                  "ErrorCode": 8,
                 "ErrorMessage": "No such house number in the street",
                "AddressLine1": "5000 DOGWOOD DR",
               "AddressLine2": "PLAINSBORO, NJ 08536",
                "Number": "5000",
                "PreDir": "",
                "Street": "DOGWOOD",
                "Suffix": "DR",
                "PostDir": "",
                "Sec": "",
                "SecNumber": "",
                "City": "PLAINSBORO",
                "State": "NJ",
                "Zip": "08536",
                "Zip4": "",
                "County": "MIDDLESEX",
                "StateFP": "34",
                "CountyFP": "023",
                "CensusTract": "86.01",
                "CensusBlock": "2070",
                "Latitude": 40.328498,
                "Longitude": -74.610901,
                "GeoPrecision": 4
                }',
                 :headers => {})
			end

			it "returns an unverified address" do
				address = AddressVerifier.verify_address "5000 Dogwood Drive", "", "Plainsboro", "New Jersey", "08536"
				expect(address.verified?).to eq(false)
			end
		end

	end
end
