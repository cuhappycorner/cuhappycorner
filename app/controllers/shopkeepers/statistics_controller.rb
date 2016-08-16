class Shopkeepers::StatisticsController < ApplicationController
	before_action :authenticate_user!
	load_and_authorize_resource :class => false
	def index
		@title = t('shopkeepers.statistics.name')
		@stat_member = User.count
		@stat_member_activated = User.where(activated: true).count
		@stat_transaction_no = Transaction.count
		@stat_transaction_amount = Transaction.sum(:credit)
		@stat_2ndhand_goodtocoop_quantity = TransactSecondHandGood.where(buy_sell: "buy").sum(:quantity)
		match = {"$match"=>{"buy_sell"=>"buy"}}
		group = {"$group"=>{"_id"=>"null",'total'=>{"$sum"=>{"$multiply"=>["$price","$quantity"]}}}}
		@stat_2ndhand_goodtocoop_amount = TransactSecondHandGood.collection.aggregate([match, group]).first.to_a[1][1]

		# where(buy_sell: "buy").sum(:price * :quantity) 
		@stat_2ndhand_goodfromcoop_quantity = TransactSecondHandGood.where(buy_sell: "sell").sum(:quantity)
		match = {"$match"=>{"buy_sell"=>"sell"}}
		group = {"$group"=>{"_id"=>"null",'total'=>{"$sum"=>{"$multiply"=>["$price","$quantity"]}}}}

		@stat_2ndhand_goodfromcoop_amount = TransactSecondHandGood.collection.aggregate([match, group]).first.to_a[1][1]


		# TransactSecondHandGood.where(buy_sell: "sell").sum(:price * :quantity)
	end
end