class ShopkeeperController < ApplicationController
	before_action :authenticate_user!
	load_and_authorize_resource :class => false

	def get_price
		@type = SecondHandGoodType.find_by(id: params[:type])
		render json: @type
	end

	# Activation - Start
	def activate_submit
		@title = t('shopkeeper_panel.activation.name')
		@user = User.find_by(cu_identity_no: params[:activate_id])
		@user.name = params[:name]
		@user.chi_name = params[:chi_name]
		@user.major = params[:major]
		@user.email = params[:email]
		@user.mobile = params[:mobile]
		@user.year_of_admission = params[:year_of_admission]
		@user.year_of_graduation = params[:year_of_graduation]
		@user.activated = true
		@user.activated_at = Time.zone.now
		@user.cu_card_id = params[:cid]
		@user.save
		redirect_to action:'activate'
	end
	def activate_get_user
		@title = t('shopkeeper_panel.activation.name')
		@activate_id = params[:activate_id]
		@user = User.find_by(cu_identity_no: params[:activate_id])
		if @user == nil
			redirect_to acction:'activate'
		end
	end
	def activate
		@title = t('shopkeeper_panel.activation.name')
	end
	# Activation - End
	# Manual Transaction - Start
	def transact_submit
		@user = User.find_by(cu_identity_no: params[:cuid])
		if @user == nil
			redirect_to action: 'transact' and return
		end
		@type = TransactionType.find_by(id: params[:type])
		if @type == nil
			redirect_to action: transact_get_user, type:"cuid", cuid: params[:cuid] and return
		end
		@cucoop = Organization.find_by(org_identifier: "cucoop")
		@transaction = nil
		@amount = params[:amount].to_f
		if params[:amount].to_f > 0
			@transaction = credit_transact_method(@cucoop, @user, params[:amount].to_f, @type, params[:remark], current_user)
		else
			@transaction = credit_transact_method(@user, @cucoop, -params[:amount].to_f, @type, params[:remark], current_user)
		end
		if @transaction == nil
			render "transact_error_not_enough_credit" and return
		else
			render "transact_success" and return
		end
	end
	def transact_get_user
		@title = t('shopkeeper_panel.transaction.name')
		@user = nil
		puts case params[:type]
		when "cid"
			@user = User.find_by(cu_card_id: params[:cid])
		when "cuid"
			@user = User.find_by(cu_identity_no: params[:cuid])
		when "email"
			@user = User.find_by(email: params[:email])
		end
		if @user == nil
			redirect_to action: 'transact' and return
		elsif !@user.activated
			render "transact_error_not_activated" and return
		else
			render "transact_get_user" and return
		end
	end

	def transact
		@title = t('shopkeeper_panel.transaction.name')
	end
	# Manual Transaction - End
	
	# 2nd Hand Good Transaction - Start
	def second_hand_good_transact_submit
		@user = User.find_by(cu_identity_no: params[:cuid])
		if @user == nil
			redirect_to action: 'second_hand_good_transact' and return
		elsif !@user.activated
			render "transact_error_not_activated" and return
		end
		@type = TransactionType.find_by(id: "2ndhand")
		@cucoop = Organization.find_by(org_identifier: "cucoop")

		@total_amount = 0
		@amount = 0
		(1..10).each do |i|
			if params[("type_"+i.to_s).to_sym] != "empty"
				@total_amount += params[("price_"+i.to_s).to_sym].to_f * params[("quantity_"+i.to_s).to_sym].to_i
			end 
		end
		@transaction = nil
		@remark = params[:remark]
		if params[:buy_sell] == "buy"
			
			@transaction = SecondHandGoodTransaction.new(operator: current_user, sender: @cucoop, recipient: @user, type: @type, credit: @total_amount,remark: @emark)
			(1..10).each do |i|
				if params[("type_"+i.to_s).to_sym] != "empty"
					@good_type = SecondHandGoodType.find_by(id: params[("type_"+i.to_s).to_sym])
					@good = @transaction.good.new(type: @good_type, price: params[("price_"+i.to_s).to_sym].to_f, quantity: params[("quantity_"+i.to_s).to_sym].to_i, buy_sell: "buy")
					@good.save
				end 
			end
			@transaction.save
			@amount = @total_amount
		elsif params[:buy_sell] == "sell"
			if (@user.credit - @total_amount) < 0
				render "transact_error_not_enough_credit" and return
			end
			@transaction = SecondHandGoodTransaction.new(operator: current_user, sender: @user, recipient: @cucoop, type: @type, credit: @total_amount,remark: @remark)
			(1..10).each do |i|
				if params[("type_"+i.to_s).to_sym] != "empty"
					@good_type = SecondHandGoodType.find_by(id: params[("type_"+i.to_s).to_sym])
					@good = @transaction.good.new(type: @good_type, price: params[("price_"+i.to_s).to_sym].to_f, quantity: params[("quantity_"+i.to_s).to_sym].to_i, buy_sell: "sell")
					@good.save
				end 
			end
			@transaction.save
			@amount = @total_amount * -1
		else
			redirect_to action: 'second_hand_good_transact' and return
		end


		if @transaction == nil
			render "transact_error_not_enough_credit" and return
		else
			render "transact_success" and return
		end
	end

	def second_hand_good_transact_get_user
		@title = t('shopkeeper_panel.second_hand_good_transaction.name')
		@user = nil
		puts case params[:type]
		when "cid"
			@user = User.find_by(cu_card_id: params[:cid])
		when "cuid"
			@user = User.find_by(cu_identity_no: params[:cuid])
		when "email"
			@user = User.find_by(email: params[:email])
		end
		if @user == nil
			redirect_to action: 'second_hand_good_transact' and return
		elsif !@user.activated
			render "transact_error_not_activated" and return
		else
			render "second_hand_good_transact_get_user" and return
		end
	end

	def second_hand_good_transact
		@title = t('shopkeeper_panel.second_hand_good_transaction.name')
	end
	# 2nd Hand Good Transaction - End

	private

	def credit_transact_method(sender, recipient, amount, type, remark, operator)
		if !sender.instance_of? Organization
			if (sender.credit - amount) < 0
				return nil
			end
		else
			if !sender.infinite_credit
				if (sender.credit - amount) < 0
					return nil
				end
			end
		end
		@transaction = CreditTransaction.create(operator: operator, sender: sender, recipient: recipient, type: type, credit: amount,remark: remark)
		return @transaction
	end
end
