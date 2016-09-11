class Banker::OrganizationalLoanController < ApplicationController
  include Bank::AccountConcern
  include Bank::LoanConcern

  before_action :authenticate_user!

  # GET
  def index
    if !current_user.role.include? Role.find_by(name:"banker")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @loans = Bank::OrganizationalLoan.all
  end

  # GET
  def show
    if !current_user.role.include? Role.find_by(name:"banker")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @loan = Bank::OrganizationalLoan.find_by_number(params[:loan_no])
  end

  # PUT
  def update
    if !current_user.role.include? Role.find_by(name:"banker")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @loan = Bank::OrganizationalLoan.find_by_number(params[:loan_no])
    if params[:approve] == "true"
      interest_rate = Array.new(@loan.no_of_instalment, params[:interest_rate].to_f/100)

      status = bank_approve_loan(current_user, @loan, interest_rate, params[:reason])
      if not status
        redirect_to action: 'show', loan_no: @loan.number and return
      end
      flash[:success] = t('Loan Approved!')
      redirect_to action: 'show', loan_no: @loan.number and return
    else
      status = bank_reject_loan(current_user, @loan, params[:reason])
      if not status
        redirect_to action: 'show', loan_no: @loan.number and return
      end
      flash[:success] = t('Loan Rejected!')
      redirect_to action: 'show', loan_no: @loan.number and return
    end
  end


end
