module PerfectMoneyMerchant
	class PaymentsController < ActionController::Base
		def status
			SCIResponse.new(sci_params).tap { |obj| obj.set_secret_key(Account::Query.new.get_secret_key(sci_params.payee_account)) }.verify!

			Payment.create!(
					payment_batch_num: sci_params.payment_batch_num,
					payment_id: sci_params.payment_id,
					payment_amount: sci_params.payment_amount,
					payer_account: sci_params.payer_account,
					payee_account: sci_params.payee_account,
			)

			Configuration.config.tasks[sci_params.payment_purpose].tap { |task| task.call(sci_params) unless task.nil? }

			render status: 200, nothing: true
		rescue StandardError => exception
			render status: 400, inline: exception.message
		end

		def success
			render status: 200, nothing: true
		end

		def error
			render status: 400, nothing: true
		end

		private

		def sci_params
			@sci_params ||= Hashie::Mash.new(params.map { |k, v| [k.downcase, v] }.inject({}) { |hash, param| hash.merge!(param[0] => param[1]) })
		end
	end
end