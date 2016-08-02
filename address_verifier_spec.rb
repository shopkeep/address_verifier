require_relative "address_verifier.rb"

include AddressVerifier

describe AddressVerifier do
	describe ".verify_address" do
		
		context "given a correct address" do
			it "returns a verified address" do
				address = AddressVerifier.verify_address "46 Dogwood Drive", "", "Plainsboro", "New Jersey", "08536"
				expect(address.verified?).to eq(true)
			end
		end

	end
end
