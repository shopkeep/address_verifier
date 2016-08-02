module AddressVerifier

	class YaddressResponse
		def verified?
			true
		end
	end

	def verify_address street_address, secondary_designators, city, state, zipcode
		YaddressResponse.new
	end
end