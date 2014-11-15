# payee_account: U1234567
# payer_account: U7654321
# payment_amount: 100.0
# payment_units: USD
# payment_batch_num: 73550837
# payment_id: okpZKCUM9sML99Qzx1t7e
# timestampgmt: 1415801831
# suggested_memo: The New Friends Payment
# additional_field_1: xxxxxx
# verification_code: xxxxxxxxxxxxxxxxxxxx
# v2_hash: 634D048EB7583DE389AF550E519CBE4C

# secret_key = SFndfsdJNFjern2D123raFDF2

class PerfectMoneyMerchant::SCIResponse
	attr_accessor :secret_key

	# Initializes PerfectMoneyMerchant::SCI::Response object
	# @param [Hash] params SCI-returned-params
	# @option params [String] :payment_id Payment ID
	# @option params [String] :payment_amount Payment amount
	# @option params [String] :payment_units Payment currency
	# @option params [String] :payment_batch_num Payment batch number
	# @option params [String] :payee_account Payee account code number
	# @option params [String] :payer_account Payer account code number
	# @option params [String] :timestampgmt Payment performance date
	# @option params [String] :v2_hash Payment verification hash
	# @option params [String] :verification_code Payment verification code
	# @option params [String] :verification_fields Payment verification fields
	def initialize(params)
		params.each_pair do |param_name, param_value|
			singleton_class.class_eval { attr_reader param_name }
			instance_variable_set("@#{param_name}", param_value)
		end

		# self.secret_key = PerfectMoneyMerchant::Account::Query.new.find_by_unit_code_number(payee_account).try(:secret_key)
	end

	def set_secret_key(secret_key)
		@secret_key = secret_key
	end

	def verify!
		check_on_secret_key!
		check_on_verification_code!
		check_on_v2_hash!
		true
	end

	alias_method :process!, :verify!

	private

	def check_on_secret_key!
		if secret_key.nil?
			raise StandardError.new('secret key is nil')
		end
	end

	def check_on_verification_code!
		if respond_to?(:verification_code) and respond_to?(:verification_fields)
			verification_values = verification_fields.split(' ').map { |field| instance_variable_get("@#{field}") }
			unless PerfectMoneyMerchant::SCI.generate_verification_code(verification_values) == verification_code
				raise StandardError.new('verification code invalid')
			end
		end
	end

	def check_on_v2_hash!
		v2_hash = Digest::MD5.hexdigest(
				[
						payment_id,
						payee_account,
						payment_amount,
						payment_units,
						payment_batch_num,
						payer_account,
						Digest::MD5.hexdigest(secret_key).upcase,
						timestampgmt
				].join(':')
		).upcase

		unless self.v2_hash == v2_hash
			raise StandardError.new('v2_hash invalid')
		end
	end

	def create_payment!
		PerfectMoneyMerchant::Payment.create!(
				payment_batch_num: payment_batch_num,
				payment_id: payment_id,
				payment_amount: payment_amount,
				payer_account: payer_account,
				payee_account: payee_account
		)
	end
end # end Response