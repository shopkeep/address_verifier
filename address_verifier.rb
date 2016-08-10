require 'faraday'
require 'json'

module AddressVerifier

	class YaddressResponse

		def initialize yaddress_json
			@json = yaddress_json
		end

		def verified?
			@json['ErrorCode'] == 0
		end

		attr_reader :json
	end

	def verify_address street_address, secondary_designators, city, state, zipcode
		address_line_1 = ("#{street_address.chomp(' ')}+#{secondary_designators.chomp(' ')}").gsub(/\s/, '+').chomp('+')
		address_line_2 = ("#{city.chomp(' ')}+#{state.chomp(' ')}+#{zipcode.chomp(' ')}").gsub(/\s/, '+').chomp('+')

		request_string = "http://www.yaddress.net/api/Address?AddressLine1=#{address_line_1}&AddressLine2=#{address_line_2}&UserKey="
		json = JSON.parse ((Faraday.get request_string).body)

		YaddressResponse.new json
	end
end