class Corner::Account::PaymentController < ApplicationController
  include Corner::AccountConcern

  before_action :authenticate_user!

  def index
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @projects = nil
    if current_user.respond_to? :corner_project
      @projects = current_user.corner_project
    end
  end

  def pay
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    project = Corner::Account::Project.find_by(number: params[:project])
    unless project.respond_to? :authorized_person
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    unless project.authorized_person.include? current_user
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end

    entity = nil
    entity = User.find_by(cuid: params[:cuid])

    amount = params[:amount].to_i
    detail = params[:detail]

    status = corner_pay_credit(current_user, entity, amount, detail, project)
    redirect_to(action: 'index') and return unless status

    flash[:success] = 'Transaction succeed. Budget Remained: ' + project.credit_budget_remained.to_s
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

  def get_project_info
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    project = Corner::Account::Project.find_by(number: params[:project])
    unless project.respond_to? :authorized_person
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    unless project.authorized_person.include? current_user
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    name = nil
    credit_budget_remained = 0
    unless project.nil?
      name = project.name
      credit_budget_remained = project.credit_budget_remained
    end
    @status = { name: name, credit_budget_remained: credit_budget_remained }
    render json: @status
    end
end
