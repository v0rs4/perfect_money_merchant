require 'perfect_money_merchant/version'

require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/response_middleware'

require 'hashie/mash'

require 'nokogiri'

module PerfectMoneyMerchant
	def self.config
		Configuration.config
	end
end

# require 'perfect_money_merchant/railtie' if defined?(Rails)
require 'perfect_money_merchant/engine'
require 'perfect_money_merchant/configuration'
require 'perfect_money_merchant/api'
require 'perfect_money_merchant/sci'
require 'perfect_money_merchant/sci_response'
require 'perfect_money_merchant/error'