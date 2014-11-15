# =AR Fields
# +payment_batch_num+
# +payment_id+
# +payment_amount+
# +payer_account+
# +payee_account+
#
class PerfectMoneyMerchant::Payment < ActiveRecord::Base
	self.table_name = 'perfect_money_merchant_payments'

	validates :payment_batch_num, :payment_amount, :payer_account, :payee_account, presence: true
end