require 'spec_helper'

RSpec.describe PerfectMoneyMerchant::PaymentsController, :type => :controller do
	context 'POST success' do
		it 'with 200' do
			post :success
			expect(response).to have_http_status(200)
		end
	end

	context 'POST error' do
		it 'with 400' do
			post :error
			expect(response).to have_http_status(400)
		end
	end

	context 'POST status' do
		before(:example) do
			PerfectMoneyMerchant::Account.create!(
					secret_key: 'SFndfsdJNFjern2D123raFDF2'
			).tap do |account|
				account.units.create!(
						{
								currency: 'usd',
								code_number: 'U1234567'
						}
				)
			end
		end

		let (:sci_params) do
			{
					payee_account: 'U1234567',
					payer_account: 'U7654321',
					payment_amount: '100.0',
					payment_units: 'USD',
					payment_batch_num: '73550837',
					payment_id: 'okpZKCUM9sML99Qzx1t7e',
					timestampgmt: '1415801831',
					suggested_memo: 'The New Friends Payment',
					v2_hash: '634D048EB7583DE389AF550E519CBE4C',
					payment_purpose: 'test_task'
			}
		end

		it 'with 200 status code' do
			post :status, sci_params
			expect(response).to have_http_status(200)
		end

		it 'with 400 status code' do
			post :status, sci_params.tap { |hash| hash[:payment_amount] = '1.0' }
			expect(response).to have_http_status(400)
		end
	end
end