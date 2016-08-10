require_relative "address_verifier.rb"

include AddressVerifier

describe AddressVerifier do

	describe ".verify_address" do

		context "given a verifiable address no secondary address" do
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

      it "returns the proper address line 1" do
        address = AddressVerifier.verify_address "46 Dogwood Drive", "", "Plainsboro", "New Jersey", "08536"
        expect(address.address_line_1).to eq('46 DOGWOOD DR')
      end

      it "returns the proper address line 2" do
        address = AddressVerifier.verify_address "46 Dogwood Drive", "", "Plainsboro", "New Jersey", "08536"
        expect(address.address_line_2).to eq('PLAINSBORO, NJ 08536-1963')
      end

  
      it "returns the proper latitude" do
         address = AddressVerifier.verify_address "46 Dogwood Drive", "", "Plainsboro", "New Jersey", "08536"
         expect(address.latitude).to eq(40.328282)
      end

      it "returns the proper longitude" do
         address = AddressVerifier.verify_address "46 Dogwood Drive", "", "Plainsboro", "New Jersey", "08536"
         expect(address.longitude).to eq(-74.611678)
      end
		end


    context "given a verifiable address with a secondary address" do
      before(:each) do
        stub_request(:get, "http://www.yaddress.net/api/Address?AddressLine1=321+E+48+Street+Apartment+4D&AddressLine2=New+York+City%2C+NY&UserKey=").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => 
              '{
                  "ErrorCode": 0,
                  "ErrorMessage": "",
                  "AddressLine1": "321 E 48TH ST APT 4D",
                  "AddressLine2": "NEW YORK, NY 10017-1731",
                  "Number": "321",
                  "PreDir": "E",
                  "Street": "48TH",
                  "Suffix": "ST",
                  "PostDir": "",
                  "Sec": "APT",
                  "SecNumber": "4D",
                  "City": "NEW YORK",
                  "State": "NY",
                  "Zip": "10017",
                  "Zip4": "1731",
                  "County": "NEW YORK",
                  "StateFP": "36",
                  "CountyFP": "061",
                  "CensusTract": "90.00",
                  "CensusBlock": "4000",
                  "Latitude": 40.753525,
                  "Longitude": -73.968901,
                  "GeoPrecision": 5
              }',
                 :headers => {})
      end

      it "returns the correct Address Line 1" do
        address = AddressVerifier.verify_address "321 E 48 Street", "Apartment 4D", "New York City,", "NY", ""
        expect(address.address_line_1).to eq("321 E 48TH ST APT 4D")
      end

      it "returns the correct Address Line 2" do
        address = AddressVerifier.verify_address "321 E 48 Street", "Apartment 4D", "New York City,", "NY", ""
        expect(address.address_line_2).to eq("NEW YORK, NY 10017-1731")
      end
    end


		context "given an unverifiable address (number doesn't exist)" do
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

      it "returns the proper error code" do
        address = AddressVerifier.verify_address "5000 Dogwood Drive", "", "Plainsboro", "New Jersey", "08536"
        expect(address.error_code).to eq(8)
      end

      it "returns the proper error message" do
        address = AddressVerifier.verify_address "5000 Dogwood Drive", "", "Plainsboro", "New Jersey", "08536"
        expect(address.error_message).to eq('No such house number in the street')
      end
		end

    context "given a faulty usercode" do
      before(:each) do
        stub_request(:get, "http://www.yaddress.net/api/Address?AddressLine1=46+Dogwood+Dr&AddressLine2=Plainsboro+NJ+08536&UserKey=45").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => 
              '{
                "ErrorCode": 1,
                "ErrorMessage": "Invalid user key. Leave blank for testing or visit www.YAddress.net to open an account.",
                "AddressLine1": null,
                "AddressLine2": null,
                "Number": null,
                "PreDir": null,
                "Street": null,
                "Suffix": null,
                "PostDir": null,
                "Sec": null,
                "SecNumber": null,
                "City": null,
                "State": null,
                "Zip": null,
                "Zip4": null,
                "County": null,
                "StateFP": null,
                "CountyFP": null,
                "CensusTract": null,
                "CensusBlock": null,
                "Latitude": 0.0,
                "Longitude": 0.0,
                "GeoPrecision": 0
              }',
                 :headers => {})
      end

      it "returns an unverified address" do
        address = AddressVerifier.verify_address "46 Dogwood Dr", "", "Plainsboro", "NJ", "08536", "45"
        expect(address.verified?).to eq(false)
      end

      it "returns the proper error code" do
        address = AddressVerifier.verify_address "46 Dogwood Dr", "", "Plainsboro", "NJ", "08536", "45"
        expect(address.error_code).to eq(1)
      end

      it "returns the proper error message" do
        address = AddressVerifier.verify_address "46 Dogwood Dr", "", "Plainsboro", "NJ", "08536", "45"
        expect(address.error_message).to eq('Invalid user key. Leave blank for testing or visit www.YAddress.net to open an account.')
      end
    end

	end
end
