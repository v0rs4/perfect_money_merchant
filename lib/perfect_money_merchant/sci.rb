module PerfectMoneyMerchant
	class SCI
		class << self
			def generate_verification_code(values)
				sha2 = Digest::SHA2.new
				values.each { |value| sha2.update(value.to_s) }
				sha2.update(Configuration.config.verification_secret)
				sha2.to_s
			end
		end

		attr_reader :payee_name
		attr_reader :payee_account
		attr_reader :payment_id
		attr_reader :payment_amount
		attr_reader :payment_units
		attr_reader :status_url
		attr_reader :payment_url
		attr_reader :payment_url_method
		attr_reader :nopayment_url
		attr_reader :nopayment_url_method
		attr_reader :suggested_memo
		attr_reader :baggage_fields
		attr_reader :payment_purpose

		def initialize(attributes = {})
			set_defaults

			set_price(attributes[:price]) if attributes[:price]
			set_currency(attributes[:currency]) if attributes[:currency]
			set_commentary(attributes[:commentary]) if attributes[:commentary]
			set_payee(attributes[:payee]) if attributes[:payee]
			set_title(attributes[:title]) if attributes[:title]
			set_additional(attributes[:additional]) if attributes[:additional]
			set_verification(attributes[:verification]) if attributes[:verification]
			set_purpose(attributes[:purpose]) if attributes[:purpose]

			verify_fields!
		end

		def set_price(price)
			@payment_amount = price
		end

		def set_commentary(commentary)
			@suggested_memo = commentary
		end

		def set_payee(payee)
			@payee_account = payee
		end

		def set_title(title)
			@payee_name = title
		end

		def set_currency(currency)
			@payment_units = currency
		end

		def set_additional(additional)
			additional.each_pair { |attr_name, attr_value| set_field(attr_name, attr_value) }
		end

		def set_purpose(purpose)
			@payment_purpose = purpose
		end

		def set_field(name, value)
			singleton_class.class_eval do
				attr_accessor name
			end
			instance_variable_set("@#{name}", value)
			set_baggage_field(name)
		end

		def set_verification(fields)
			set_field(:verification_code, self.class.generate_verification_code(fields.map { |field| send(field).to_s }))
			set_field(:verification_fields, fields.join(' '))
		end

		def to_hash
			instance_variables.inject({}) { |hash, variable| hash.merge({ variable.to_s.delete('@').to_sym => instance_variable_get(variable) }) }
		end

		private

		def verify_fields!
			raise StandardError.new('payee_name is nil') if payee_name.nil?
			raise StandardError.new('suggested_memo is nil') if suggested_memo.nil?
			raise StandardError.new('payment_units is nil') if payment_units.nil?
			raise StandardError.new('payee_account is nil') if payee_account.nil?
			raise StandardError.new('status_url is nil') if status_url.nil?
			raise StandardError.new('payment_url is nil') if payment_url.nil?
			raise StandardError.new('payment_url_method is nil') if payment_url_method.nil?
			raise StandardError.new('nopayment_url is nil') if nopayment_url.nil?
			raise StandardError.new('nopayment_url_method is nil') if nopayment_url_method.nil?
			raise StandardError.new('payment_purpose is nil') if payment_purpose.nil?
		end

		def set_defaults
			config = Configuration.config

			@payee_name = config.payee_name || 'Perfect Money Merchant'
			@suggested_memo = config.suggested_memo || 'Perfect Money Merchant Payment'
			@payment_units = config.payment_units || 'USD'
			@status_url = config.status_url || '/perfect_money_merchant/payment/status'
			@payment_url = config.payment_url || '/perfect_money_merchant/payment/success'
			@payment_url_method = config.payment_url_method || 'POST'
			@nopayment_url = config.nopayment_url || '/perfect_money_merchant/payment/error'
			@nopayment_url_method = config.nopayment_url_method || 'POST'
			@baggage_fields = ''
		end

		def set_baggage_field(field_name)
			baggage_fields_tmp = baggage_fields.split(' ')
			baggage_fields_tmp << field_name
			@baggage_fields = baggage_fields_tmp.join(' ')
		end
	end
end