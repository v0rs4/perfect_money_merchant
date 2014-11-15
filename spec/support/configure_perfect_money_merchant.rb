Rails.application.routes.default_url_options[:host] = 'example.com'

Rails.application.configure do
	config.after_initialize do
		routes = Object.new.tap { |obj| obj.singleton_class.class_eval { include Rails.application.routes.url_helpers } }

		PerfectMoneyMerchant::Configuration.configure do |config|
			config.verification_secret = 'SEfxvsdrwer3rdsczdr3'

			config.payee_name = 'Perfect Money Spec'
			config.suggested_memo = 'Perfect Money Spec Commentary'
			config.payment_units = 'usd'
			config.status_url = routes.status_perfect_money_merchant_payment_url
			config.payment_url = routes.success_perfect_money_merchant_payment_url
			config.nopayment_url = routes.error_perfect_money_merchant_payment_url
			config.payment_url_method = 'POST'

			config.nopayment_url_method = 'POST'

			config.add_task :test_task, ->(sci_params) {
				# some code
			}
		end
	end
end