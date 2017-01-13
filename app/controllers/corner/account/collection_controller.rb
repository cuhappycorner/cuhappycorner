class Corner::Account::CollectionController < ApplicationController
  include Corner::AccountConcern

  before_action :authenticate_user!

  def index
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  def collect
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    entity = nil
    puts case params[:id_type]
         when 'cuid'
           entity = User.find_by(cuid: params[:cuid])
         when 'cu_link_id'
           entity = User.find_by(cu_link_id: params[:cu_link_id])
    end
    amount = params[:amount].to_i
    detail = params[:detail]

    status = corner_collect_credit(current_user, entity, amount, detail)
    redirect_to(action: 'index') and return unless status

    flash[:success] = 'Transaction succeed. Credit Remained: ' + entity.account.balance.to_s
    redirect_to(action: 'index') and return
  end

  def get_info
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    exist = false
    entity = nil
    name = nil
    activated = false
    balance = 0
    case params[:id_type]
    when 'cuid'
      entity = User.find_by(cuid: params[:cuid])
    when 'cu_link_id'
      entity = User.find_by(cu_link_id: params[:cu_link_id])
    end
    unless entity.nil?
      exist = true
      name = entity.name
      unless entity.account.nil?
        activated = true
        balance = entity.account.balance
      end
    end
    @status = { exist: exist, name: name, activated: activated, balance: balance }
    render json: @status
  end
end
