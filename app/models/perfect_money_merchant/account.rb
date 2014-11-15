module PerfectMoneyMerchant
	class Account < ActiveRecord::Base
		class Unit < ActiveRecord::Base
			self.table_name = 'perfect_money_merchant_account_units'

			belongs_to :account, class_name: 'Account', foreign_key: :account_id

			# transfer money to other PerfectMoney account
			# @param [String] PerfectMoney account code number
			# @param [Float] just desirable amount to trasnfer
			# @return [Hash] PerfectMoney http response body
			def transfer!(payee_account, amount)
				Api.new.transfer(
						AccountID: self.account.login,
						PassPhrase: self.account.password,
						Payer_Account: self.code_number,
						Payee_Account: payee_account,
						Amount: amount
				)
			end

			after_create :sync_with_pm_server

			# unit synchronization with perfect money server
			def sync_with_pm_server
				account.sync_with_pm_server
			end
		end

		class Query
			attr_reader :relation

			def initialize(relation = Account.all)
				@relation = relation
			end

			# find account by unit's code number
			# @param [String] code number
			# @return [PerfectMoneyMerchant::Account]
			def find_by_unit_code_number(code_number)
				relation.joins(:units).where(perfect_money_merchant_account_units: { code_number: code_number }).take(1).first
			end

			def get_secret_key(code_number)
				find_by_unit_code_number(code_number).try(:secret_key)
			end
		end

		self.table_name = 'perfect_money_merchant_accounts'

		has_many :units, class_name: 'Account::Unit', foreign_key: :account_id

		# Synchronize account unit balances with Perfect Money server via PerfectMoneyMerchant::Api
		# @see PerfectMoneyMerchant::Api PerfectMoneyMerchant Api
		# @return [PerfectMoneyMerchant::Account] itself
		def sync_with_pm_server
			response = Api.new.balance(AccountID: login, PassPhrase: password)
			response.each_pair do |code_number, balance|
				units.each do |unit|
					unit.update!(balance: balance) if unit.code_number == code_number
				end
			end
			self
		end

		# Transfer money to whatever perfect money account
		# @param [String] payee_account payee account code number
		# @param [Float] amount amount of money
		# @return [Hash] Perfect Money http response body
		def transfer!(payee_account, amount)
			if payee_account =~ /\A([UE])\d{7}\z/
				currency = $1 == 'U' ? 'usd' : 'eur'
				unit = units.where(currency: currency).where('balance > ?', amount).order('balance DESC').take(1).first
				if unit.nil?
					exception = BasicError.new('no unit was found')
					exception.add_error(:unit, :not_found)
					raise exception
				else
					unit.transfer!(payee_account, amount).tap do
						sync_with_pm_server
					end
				end
			else
				exception = BasicError.new('invalid payee_account')
				exception.add_error(:payee_account, :invalid)
				raise exception
			end
		end

		class << self
			# Obtain the most suitable deposit account from database
			# @param [String] currency currency like 'usd' or 'eur'
			# @return [String] PerfectMoney account code number
			def obtain_deposit_account(currency)
				unit = Account::Unit.
						joins(:account).
						where.not(perfect_money_merchant_accounts: { secret_key: nil }).
						where(currency: currency).
						order('balance ASC').take(1).first
				if unit
					unit.code_number
				else
					raise BasicError.new('no unit was found').tap do |exception|
						exception.add_error(:unit, :not_found)
					end
				end
			end

			# Transfer money to whatever perfect money account
			# @param [String] payee_account payee account code number
			# @param [Float] amount amount of money
			# @return [Hash] Perfect Money http response body
			#
			# PerfectMoneyMerchant::Account.transfer('U8259997',0.01)
			def transfer!(payee_account, amount)
				if payee_account =~ /\A([UE])\d{7}\z/
					currency = $1 == 'U' ? 'usd' : 'eur'
					account = joins(:units).
							where.not(login: nil, password: nil).
							where(perfect_money_merchant_account_units: { currency: currency }).
							where('perfect_money_merchant_account_units.balance > ?', amount).
							order('perfect_money_merchant_account_units.balance DESC').
							take(1).first
					if account.nil?
						raise StandardError.new('account nil')
					else
						account.transfer!(payee_account, amount)
					end
				else
					raise BasicError.new('invalid payee_account').tap do |exception|
						exception.add_error(:payee_account, :invalid)
					end
				end
			end
		end
	end
end
