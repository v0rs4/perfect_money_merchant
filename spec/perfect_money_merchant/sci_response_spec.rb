require 'spec_helper'

RSpec.describe PerfectMoneyMerchant::SCIResponse do
	SECRET_KEY = 'SFndfsdJNFjern2D123raFDF2'

	let (:sci_response) do
		PerfectMoneyMerchant::SCIResponse.new(
				payee_account: 'U1234567',
				payer_account: 'U7654321',
				payment_amount: '100.0',
				payment_units: 'USD',
				payment_batch_num: '73550837',
				payment_id: 'okpZKCUM9sML99Qzx1t7e',
				timestampgmt: '1415801831',
				suggested_memo: 'The New Friends Payment',
				v2_hash: '634D048EB7583DE389AF550E519CBE4C'
		)
	end

	context '#initialize' do
		it 'should convert params into fields' do
			expect(sci_response).to respond_to(:payee_account)
			expect(sci_response).to respond_to(:payer_account)
			expect(sci_response).to respond_to(:payment_amount)
			expect(sci_response).to respond_to(:payment_units)
			expect(sci_response).to respond_to(:payment_batch_num)
			expect(sci_response).to respond_to(:payment_id)
			expect(sci_response).to respond_to(:timestampgmt)
			expect(sci_response).to respond_to(:suggested_memo)
			expect(sci_response).to respond_to(:v2_hash)
		end
	end

	context '#verify?' do
		before(:example) do
			sci_response.set_secret_key(SECRET_KEY)
		end

		it 'should return true' do
			expect(sci_response.verify!).to be_truthy
		end

		context 'should raise error' do
			it 'v2_hash' do
				sci_response.instance_variable_set('@payee_account', 'U1234568')
				expect { sci_response.verify! }.to raise_error(/v2_hash invalid/)
			end
		end
	end
end