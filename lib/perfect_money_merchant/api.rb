class PerfectMoneyMerchant::Api
	class ParseResponse < ::FaradayMiddleware::ResponseMiddleware
		dependency do
			require 'nokogiri' unless defined? ::Nokogiri
		end
		define_parser do |body|
			Nokogiri::HTML.parse(body).search('//input').inject({}) { |hash, field| hash.merge({ field['name'] => field['value'] }) }
		end
	end

	Faraday::Response.register_middleware parse_pm_response: ParseResponse

	API_URL = 'https://perfectmoney.is'.freeze
	METHODS = {
			balance: {
					path: 'acct/balance.asp',
					donwcase_params: false
			},
			transfer: {
					path: 'acct/confirm.asp',
					donwcase_params: true
			}
	}

	def method_missing(*args, &block)
		if METHODS.include?(args[0])
			response_hash = api_call(METHODS[args[0]][:path], args[1])
			if METHODS[args[0]][:donwcase_params]
				response_hash.map { |k, v| [k.downcase, v] }.inject(Hashie::Mash.new) { |hash, param| hash.merge!(param[0] => param[1]) }
			else
				Hashie::Mash.new(response_hash)
			end
		else
			super
		end
	end

	private

	def api_call(path, params)
		@response = connection.post(path, params)
		@response.body
	end

	def connection
		@connection ||= ::Faraday.new(url: API_URL.dup) do |faraday|
			faraday.request :url_encoded
			faraday.response :parse_pm_response
			faraday.adapter Faraday.default_adapter
		end
	end
end