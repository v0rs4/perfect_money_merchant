ENV['RAILS_ENV'] = 'test'

require File.expand_path('../rails_test_app/config/environment', __FILE__)

class String::Generator
	def initialize(length)
		generate(length)
	end

	private

	def generate(length)
		o = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
		(0..length).map { o[rand(o.length)] }.join
	end
end

PerfectMoneyMerchant::SCI.class_eval do
	def self.generate_response(sci, secret_key)
		Hash.new.tap do |hash|
			hash[:payment_id] = sci.payment_id.blank? ? String::Generator.new(10) : sci.payment_id
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

PerfectMoneyMerchant::Configuration.configure do |config|
	config.verification_secret = 'SEfxvsdrwer3rdsczdr3'
	config.add_task :test_task, ->(params) {
		# some code
	}
end

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Migrator.migrate File.expand_path('../rails_test_app/db/migrate/', __FILE__)

require 'rspec/rails'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
	config.around do |example|
		ActiveRecord::Base.transaction do
			example.run
			raise ActiveRecord::Rollback
		end
	end
	config.order = 'random'
end