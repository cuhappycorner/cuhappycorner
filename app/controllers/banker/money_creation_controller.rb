class Banker::MoneyCreationController < ApplicationController
  include Bank::AccountConcern
  include Bank::LoanConcern

  before_action :authenticate_user!

  # GET
  def index
    unless current_user.role.include? Role.find_by(name: 'banker')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  # POST
  def create
    unless current_user.role.include? Role.find_by(name: 'banker')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end

    account = HappyCorner.first.account.first

    @loan = bank_request_loan(current_user, account, params[:amount], 9999999, "Money Creation")
    redirect_to(request.referrer || root_path) and return unless @loan

    interest_rate = Array.new(2, 0)
    status = bank_approve_loan(current_user, @loan, interest_rate, "Money Creation")
    redirect_to(action: 'show', loan_no: @loan.number) and return unless status

    flash[:success] = t('Oh God! Money Created!')
    redirect_to(request.referrer || root_path) and return
  end

end