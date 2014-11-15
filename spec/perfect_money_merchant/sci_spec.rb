require 'spec_helper'

RSpec.describe PerfectMoneyMerchant::SCI do
	let(:sci) do
		PerfectMoneyMerchant::SCI.new(
				payee: 'U1234567',
				price: 10.0,
				currency: 'usd',
				additional: {
						merchandise_name: 'oak field'
				},
				purpose: 'merchandise',
				verification: [:merchandise_name]
		)
	end

	context '#set_field' do
		before(:example) do
			sci.set_field(:some_new_field, 'some_value')
		end

		it 'should dynamically create attribute' do
			expect(sci).to respond_to(:some_new_field)
		end

		it 'created attribute should has value' do
			expect(sci.some_new_field).to eql('some_value')
		end
	end

	describe '#initialize' do
		it 'should has correct payment_amount' do
			expect(sci.payment_amount).to eql(10.0)
		end

		it 'should has verification attributes' do
			expect(sci.verification_code.class).to eql(String)
			expect(sci.verification_fields.class).to eql(String)
		end

		it 'should has additional fields' do
			expect(sci.merchandise_name).to eql('oak field')
		end

		it 'expected baggage fields contain additional fields' do
			expect(sci.baggage_fields.split(' ')).to include('merchandise_name')
		end
	end
end