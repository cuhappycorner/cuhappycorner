class Corner::Pos::SecondHandGoodTransactionController < ApplicationController
  include Corner::PosConcern
  before_action :authenticate_user!

  # GET
  def index
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  def new
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @user = nil
    puts case params[:id_type]
         when 'cuid'
           @user = User.find_by(cuid: params[:cuid])
         when 'cu_link_id'
           @user = User.find_by(cu_link_id: params[:cu_link_id])
    end
    if @user.nil?
      flash[:alert] = 'User Not Found'
      redirect_to(action: 'index') and return
    elsif !@user.activated
      flash[:alert] = 'User Not Activated'
      redirect_to(action: 'index') and return
    end
  end

  def create
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @user = User.find_by(cuid: params[:cuid])
    if @user.nil?
      flash[:alert] = 'User Not Found'
      redirect_to(action: 'index') and return
    elsif !@user.activated
      flash[:alert] = 'User Not Activated'
      redirect_to(action: 'index') and return
    end
    type = ''
    type = if params[:type] == 'purchase'
             'purchase'
           else
             'sale'
           end

    @item_array = []

    (1..10).each do |i|
      next unless params[('good_' + i.to_s).to_sym] != 'empty' && params[('quantity_' + i.to_s).to_sym].to_i > 0
      # @total_amount += params[("price_"+i.to_s).to_sym].to_f * params[("quantity_"+i.to_s).to_sym].to_i
      good = Corner::Pos::SecondHandGood.find_by_number(params[('good_' + i.to_s).to_sym])
      quantity = params[('quantity_' + i.to_s).to_sym].to_i
      flow_type = ''
      purchase_credit_price = 0
      purchase_cash_price = 0
      sale_credit_price = 0
      sale_cash_price = 0
      if type == 'purchase'
        purchase_credit_price = params[('price_' + i.to_s).to_sym].to_i
        flow_type = 'debit'
      else
        sale_credit_price = params[('price_' + i.to_s).to_sym].to_i
        flow_type = 'credit'
      end
      @item_array << { 'flow_type' => flow_type, 'quantity' => quantity, 'product' => good, 'purchase_credit_price' => purchase_credit_price, 'purchase_cash_price' => purchase_cash_price, 'sale_credit_price' => sale_credit_price, 'sale_cash_price' => sale_cash_price }
    end

    status = corner_pos_create_transaction(current_user, @user, @item_array)
    redirect_to(action: 'index') and return unless status

    flash[:success] = 'Transaction succeed. Credit Remained: ' + @user.account.balance.to_s
    redirect_to(action: 'index') and return
  end

  def get_price
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @good = Corner::Pos::SecondHandGood.find_by_number(params[:good])
    render json: @good
  end
end
