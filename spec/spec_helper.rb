ENV['RAILS_ENV'] = 'test'

require File.expand_path('../rails_test_app/config/environment', __FILE__)
require File.expand_path('../support/perfect_monet_merchant_test_helpers', __FILE__)
require File.expand_path('../support/configure_perfect_money_merchant', __FILE__)
require File.expand_path('../support/configure_active_record', __FILE__)

require 'rspec/rails'

Rails.backtrace_cleaner.remove_silencers!

class StringGenerator
	def generate(length)
		o = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
		(0..length).map { o[rand(o.length)] }.join
	end

	def self.generate(length)
		new.generate(length)
	end
end

RSpec.configure do |config|
	config.around do |example|
		ActiveRecord::Base.transaction do
			example.run
			raise ActiveRecord::Rollback
		end
	end
	config.order = 'random'
end