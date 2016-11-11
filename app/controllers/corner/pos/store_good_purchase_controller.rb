class Corner::Pos::StoreGoodPurchaseController < ApplicationController
  include Corner::PosConcern
  before_action :authenticate_user!

  # GET
  def index
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  def new
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @user = nil
    puts case params[:id_type]
    when "cuid"
      @user = User.find_by(cuid: params[:cuid])
    when "cu_link_id"
      @user = User.find_by(cu_link_id: params[:cu_link_id])
    end
    if @user == nil
      flash[:alert] = "User Not Found"
      redirect_to action: 'index' and return
    elsif !@user.activated
      flash[:alert] = "User Not Activated"
      redirect_to action: 'index' and return
    end
  end

  def create
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @user = User.find_by(cuid: params[:cuid])
    if @user == nil
      flash[:alert] = "User Not Found"
      redirect_to action: 'index' and return
    elsif !@user.activated
      flash[:alert] = "User Not Activated"
      redirect_to action: 'index' and return
    end
    @item_array = Array.new()

    (1..10).each do |i|
      if params[("good_"+i.to_s).to_sym] != "empty" && params[("quantity_"+i.to_s).to_sym].to_i > 0
        # @total_amount += params[("price_"+i.to_s).to_sym].to_f * params[("quantity_"+i.to_s).to_sym].to_i
        good = Corner::Pos::StoreGood.find_by_number(params[("good_"+i.to_s).to_sym])  
        quantity = params[("quantity_"+i.to_s).to_sym].to_i
        flow_type = ""
        purchase_credit_price = 0
        purchase_cash_price = 0
        sale_credit_price = 0
        sale_cash_price = 0

        # purchase_credit_price = params[("price_"+i.to_s).to_sym].to_i
        # purchase_cash_price = params[("cash_"+i.to_s).to_sym].to_i

        purchase_credit_price = getprice(("price_"+i.to_s).to_sym).purchase_credit_price
        purchase_cash_price = getprice(("cash_"+i.to_s).to_sym).purchase_cash_price

        flow_type = "credit"
        
        @item_array << {'flow_type' => flow_type, 'quantity' => quantity, 'product' => good, 'purchase_credit_price' => purchase_credit_price, 'purchase_cash_price' => purchase_cash_price, 'sale_credit_price' => sale_credit_price, 'sale_cash_price' => sale_cash_price}
      end 
    end

    status = corner_pos_create_transaction(current_user, @user, @item_array)
    if !status
      redirect_to(action: "index") and return
    end

    flash[:success] = "Transaction succeed. Credit Remained: "+ @user.account.balance.to_s
    redirect_to(action: "index") and return
  end

  def get_price
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @good = Corner::Pos::StoreGood.find_by_number(params[:good])
    render json: @good
  end
end