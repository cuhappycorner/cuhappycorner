class Corner::Loan::LoanController < ApplicationController
  include Corner::LoanConcern
  before_action :authenticate_user!

  def index
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  def show
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(action: "index") and return
    end
    member = nil
    if params[:cuid] != nil and params[:cuid] != ""
      member = User.find_by(cuid: params[:cuid])
    elsif params[:cu_link_id] != nil and params[:cu_link_id] != ""
      member = User.find_by(cu_link_id: params[:cu_link_id])
    end
    if member == nil
      flash[:alert] = "Member Not Existed"
      redirect_to(action: "index") and return
    elsif member.activated == false
      flash[:alert] = "Member Not Activated"
      redirect_to(action: "index") and return
    end

    @loans = member.individual_loan
    @loan_amount = member.individual_loan_amount
    @loan_amount = 0 if member.individual_loan_amount == nil
    @cuid = member.cuid
  end

  def create
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    member = User.find_by(cuid: params[:cuid])
    if member == nil
      flash[:alert] = "Member Not Existed"
      redirect_to(action: "index") and return
    elsif member.activated == false
      redirect_to(action: "index") and return
    end

    if corner_drawdown_loan(current_user, member, params[:amount])
      flash[:success] = "Loan created successfully"
      redirect_to(action: "show", cuid: member.cuid) and return
    else
      redirect_to(action: "show", cuid: member.cuid) and return
    end
  end

  def update
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    member = User.find_by(cuid: params[:cuid])
    if member == nil
      flash[:alert] = "Member Not Existed"
      redirect_to(action: "index") and return
    elsif member.activated == false
      redirect_to(action: "index") and return
    end

    loan = Corner::Loan::Loan.find_by_number(params[:loan_no])
    if loan == nil
      flash[:alert] = "Loan not found"
      redirect_to(action: "show", cuid: member.cuid) and return
    elsif loan.status == 2
      flash[:alert] = "Loan has already repayed"
      redirect_to(action: "show", cuid: member.cuid) and return
    end

    amount = params[:amount].to_i

    if corner_repay_loan(current_user, member, loan, amount)
      flash[:success] = "Loan repayed successfully, please return him/her HKD$" + amount.to_s
      redirect_to(action: "show", cuid: member.cuid) and return
    else

      redirect_to(action: "show", cuid: member.cuid) and return
    end

  end
end
