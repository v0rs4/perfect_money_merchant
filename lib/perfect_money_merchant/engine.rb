require 'rails/engine'
require 'perfect_money_merchant'

class PerfectMoneyMerchant::Engine < Rails::Engine #:nodoc:
	config.perfect_money_merchant = PerfectMoneyMerchant
end