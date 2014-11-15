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
			balance: 'acct/balance.asp',
			transfer: 'acct/confirm.asp'
	}

	def method_missing(*args, &block)
		if METHODS.include?(args[0])
			api_call(METHODS[args[0]], args[1])
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