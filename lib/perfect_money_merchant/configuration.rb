module PerfectMoneyMerchant
	class Configuration
		FIELDS = [:payee_name, :payment_units, :status_url, :payment_url, :payment_url_method, :nopayment_url, :nopayment_url_method, :suggested_memo, :verification_secret]

		class << self
			def configure
				@config ||= Configuration.new
				yield(@config) if block_given?
				# valid_fields!
				@config
			end

			def config
				@config
			end

			def valid_fields!
				raise StandardError.new('verification_secret is nil') if @config.verification_secret.nil?

				# if FIELDS.map { |field_name| @config.instance_variable_get("@#{field_name}") }.include?(nil)
				# 	raise StandardError.new('all fields must be initiated')
				# end
			end
		end

		attr_accessor *FIELDS
		attr_reader :tasks

		def initialize
			@tasks = Hashie::Mash.new
		end

		def verification_secret
			if @verification_secret
				@verification_secret
			else
				raise StandardError.new('verification_secret is nil')
			end
		end

		def add_task(task_name, block)
			@tasks ||= Hashie::Mash.new
			@tasks[task_name] = block
		end
	end
end