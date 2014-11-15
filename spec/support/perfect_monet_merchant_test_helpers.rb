PerfectMoneyMerchant::SCI.class_eval do
	def self.generate_response(sci, secret_key)
		Hash.new.tap do |hash|
			hash[:payment_id] = sci.payment_id.blank? ? StringGenerator.generate(10) : sci.payment_id
			hash[:payee_account] = sci.payee_account
			hash[:payment_amount] = sci.payment_amount.to_s
			hash[:payment_units] = sci.payment_units.upcase
			hash[:payment_batch_num] = '12345'
			hash[:payer_account] = 'U1234567'
			hash[:timestampgmt] = '12345'
			hash[:v2_hash] = Digest::MD5.hexdigest(
					[
							hash[:payment_id],
							hash[:payee_account],
							hash[:payment_amount],
							hash[:payment_units],
							hash[:payment_batch_num],
							hash[:payer_account],
							Digest::MD5.hexdigest(secret_key).upcase,
							hash[:timestampgmt]
					].join(':')
			).upcase
		end
	end
end