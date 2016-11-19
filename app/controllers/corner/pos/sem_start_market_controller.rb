class Corner::Pos::SemStartMarketController < ApplicationController
  include Corner::PosConcern
  before_action :authenticate_user!

  # GET
  def index
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  def create
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    good1 = Corner::Pos::SemStartMarketGood.find_by(name: 'Group 1 Item - SemStart Market')
    good2 = Corner::Pos::SemStartMarketGood.find_by(name: 'Group 2 Item - SemStart Market')
    good3 = Corner::Pos::SemStartMarketGood.find_by(name: 'Group 3 Item - SemStart Market')
    good4 = Corner::Pos::SemStartMarketGood.find_by(name: 'Group 4 Item - SemStart Market')
    good5 = Corner::Pos::SemStartMarketGood.find_by(name: 'Group 5 Item - SemStart Market')

    member = User.find_by(cuid: params[:cuid])

    good1_q = params[:grp1_no].to_i
    good2_q = params[:grp2_no].to_i
    good3_q = params[:grp3_no].to_i
    good4_q = params[:grp4_no].to_i
    good5_q = params[:grp5_no].to_i

    @item_array = []
    @item_array << { 'flow_type' => 'credit', 'quantity' => good1_q, 'product' => good1 } if good1_q > 0
    @item_array << { 'flow_type' => 'credit', 'quantity' => good2_q, 'product' => good2 } if good2_q > 0
    @item_array << { 'flow_type' => 'credit', 'quantity' => good3_q, 'product' => good3 } if good3_q > 0
    @item_array << { 'flow_type' => 'credit', 'quantity' => good4_q, 'product' => good4 } if good4_q > 0
    @item_array << { 'flow_type' => 'credit', 'quantity' => good5_q, 'product' => good5 } if good5_q > 0

    status = corner_pos_create_transaction(current_user, member, @item_array)
    redirect_to(action: 'index') and return unless status

    flash[:success] = 'Transaction succeed. Credit Remained: ' + member.account.balance.to_s
    redirect_to(action: 'index') and return
  end

  def get_user_status
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    exist = false
    name = ''
    activated = false
    balance = 0
    cuid = ''
    if !params[:cuid].nil?
      user = User.find_by(cuid: params[:cuid])
      unless user.nil?
        exist = true
        name = user.name
        cuid = user.cuid
        if user.activated == true
          activated = true
          balance = user.account.balance
        end
      end
    elsif !params[:cu_link_id].nil?
      user = User.find_by(cu_link_id: params[:cu_link_id])
      unless user.nil?
        exist = true
        name = user.name
        cuid = user.cuid
        if user.activated == true
          activated = true
          balance = user.account.balance
        end
      end
    end
    @status = { exist: exist, name: name, activated: activated, balance: balance, cuid: cuid }
    render json: @status
  end
end
