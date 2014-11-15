# require 'spec_helper'
#
# PerfectMoneyMerchant::Configuration.class_eval do
# 	def self.reset
# 		@config = nil
# 	end
# end
#
# RSpec.describe PerfectMoneyMerchant::Configuration do
# 	context '.configure' do
# 		# it 'should yield with class instance' do
# 		# 	expect { |b| described_class.configure(&b) }.to yield_with_args(described_class)
# 		# end
# 		#
# 		# it 'should return class instance' do
# 		# 	expect(described_class.configure).to be_a(described_class)
# 		# end
#
# 		it 'should initialize configuration instance' do
# 			config = described_class.configure do |config|
# 				config.verification_secret = 'SEfxvsdrwer3rdsczdr3'
# 				config.payee_name = 'Perfect Money Spec'
# 				config.suggested_memo = 'Perfect Money Spec Commentary'
# 				config.payment_units = 'usd'
# 				config.status_url = ''
# 				config.payment_url = ''
# 				config.nopayment_url = ''
# 				config.payment_url_method = 'POST'
# 				config.nopayment_url_method = 'POST'
# 			end
#
# 			expect(config).to be_a(described_class)
# 		end
#
# 		it 'should raise validation fields error' do
# 			expect do
# 				described_class.configure do |config|
# 					config.verification_secret = 'SEfxvsdrwer3rdsczdr3'
# 					config.payee_name = 'Perfect Money Spec'
# 					config.suggested_memo = 'Perfect Money Spec Commentary'
# 					# config.payment_units = 'usd'
# 					config.status_url = ''
# 					config.payment_url = ''
# 					config.nopayment_url = ''
# 					config.payment_url_method = 'POST'
# 					config.nopayment_url_method = 'POST'
# 				end
# 			end.to raise_error
# 		end
# 	end
# end