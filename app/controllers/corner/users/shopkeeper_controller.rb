class Corner::Users::ShopkeeperController < ApplicationController
  include Corner::SalaryConcern

  before_action :authenticate_user!

  def index
    if (!current_user.role.include? Role.find_by(name: 'shopkeeper_manager')) && (!current_user.role.include? Role.find_by(name: 'board'))
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @shopkeepers = Role.find_by(name: 'shopkeeper').user.order_by(name: :asc)
    @salary_records = Corner::Account::SalaryCreditTransaction.all.order_by(c_at: :desc)
  end

  def distribute
    if (!current_user.role.include? Role.find_by(name: 'shopkeeper_manager')) && (!current_user.role.include? Role.find_by(name: 'board'))
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    entity = nil
    entity = User.find_by(cuid: params[:cuid])

    amount = params[:amount].to_i
    detail = params[:detail]

    status = corner_distribute_salary(current_user, entity, amount, detail)
    redirect_to(action: 'index') and return unless status

    flash[:success] = 'Salary distribution succeed.'
    redirect_to(action: 'index') and return
  end

  def get_user_info
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    exist = false
    entity = nil
    name = nil
    activated = false
    balance = 0
    entity = User.find_by(cuid: params[:cuid])

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
