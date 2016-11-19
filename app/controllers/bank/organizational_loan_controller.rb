class Bank::OrganizationalLoanController < ApplicationController
  include Bank::LoanConcern

  before_action :authenticate_user!

  # GET
  def index
    @account = Bank::OrganizationalAccount.find_by_number(params[:account_no])
    if @account.authorized_person.include? current_user
      @loans = @account.loan.all
    else
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  # GET
  def new
    @account = Bank::OrganizationalAccount.find_by_number(params[:account_no])
    unless @account.authorized_person.include? current_user
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  # POST
  def create
    @account = Bank::OrganizationalAccount.find_by_number(params[:account_no])
    if @account.authorized_person.include? current_user
      @loan = bank_request_loan(current_user, @account, params[:amount], params[:no_of_instalment], params[:remark])
      redirect_to(request.referrer || root_path) and return unless @loan
      flash[:success] = t('TODO')
      redirect_to(action: 'index', account_no: params[:account_no]) and return
      # redirect_to action: 'show', loan_no: @loan.number
    else
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  # GET
  def show
    @loan = Bank::OrganizationalLoan.find_by_number(params[:loan_no])
    unless @loan.borrower_account.authorized_person.include? current_user
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end
end
