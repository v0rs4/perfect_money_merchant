Rails.application.routes.draw do
	namespace :perfect_money_merchant do
		resource :payment, only: [] do
			post 'status' #, as: 'perfect_money_merchant_payment_status'
			post 'success' #, as: 'perfect_money_merchant_payment_success'
			post 'error' #, as: 'perfect_money_merchant_payment_error'
		end
	end
end