module PerfectMoneyMerchant
	class BasicError < StandardError
		attr_reader :errors

		def add_error(name, value)
			@errors ||= Hashie::Mash.new
			@errors[name] = value # TODO: add I18n
		end
	end
end