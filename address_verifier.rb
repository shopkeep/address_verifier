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

		def error_code
			@json['ErrorCode']
		end

		def error_message
			@json['ErrorMessage']
		end

		#Various components of the address:
		def address_line_1
			@json['AddressLine1']
		end

		def address_line_2
			@json['AddressLine2']
		end

		def latitude
			@json['Latitude']
		end

		def longitude
			@json['Longitude']
		end
	end

	def verify_address street_address, secondary_designators, city, state, zipcode, user_key = nil
		address_line_1 = ("#{street_address.chomp(' ')}+#{secondary_designators.chomp(' ')}").gsub(/\s/, '+').chomp('+')
		address_line_2 = ("#{city.chomp(' ')}+#{state.chomp(' ')}+#{zipcode.chomp(' ')}").gsub(/\s/, '+').chomp('+')

		request_string = "http://www.yaddress.net/api/Address?AddressLine1=#{address_line_1}&AddressLine2=#{address_line_2}&UserKey="
		
		if user_key.nil? == false
			request_string = "#{request_string}#{user_key}"
		end
		
		json = JSON.parse ((Faraday.get request_string).body)

		YaddressResponse.new json
	end
end