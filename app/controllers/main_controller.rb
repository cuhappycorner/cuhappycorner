class MainController < ApplicationController
	before_action :authenticate_user!
	def index
		@title = t('index.name')
		@credit = current_user.credit
		@transactions_sent = current_user.transactions_sent
		@transactions_receive = current_user.transactions_receive
		@transactions = (@transactions_sent + @transactions_receive).sort_by(&:created_at).reverse!
	end
end
