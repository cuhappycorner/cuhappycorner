class Corner::Loan::LoanController < ApplicationController
  include Corner::LoanConcern
  before_action :authenticate_user!

  def index
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @loans = Corner::Loan::Loan.all
  end

  def export_data
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @loans = Corner::Loan::Loan.all

    head = 'EF BB BF'.split(' ').map{|a|a.hex.chr}.join()
    header = ['Loan No.', 'Member', 'CUID', 'Amount', 'Repayed Amount', 'Date of Borrowing', 'Deadline', 'Status']
    file  = CSV.generate(csv = head) do |csv|
      csv << header
      @loans.each do |loan|
        temp = nil
        case loan.status
          when 1
            temp = "Approved"
          when 2
            temp = "Fully Repaid"
          when 3
            temp = "Bad debt"
        end
        csv << [loan.number, loan.member.name, loan.member.cuid, loan.amount, loan.repayed_amount, loan.created_at, loan.deadline, temp]
      end
    end
    send_data file, filename: "Loan-Statistics-#{Time.now.strftime("%y%m%d%H%M%S")}.csv", type: "text/csv"
  end

  def show
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(action: 'index') and return
    end
    member = nil
    if !params[:cuid].nil? && (params[:cuid] != '')
      member = User.find_by(cuid: params[:cuid])
    elsif !params[:cu_link_id].nil? && (params[:cu_link_id] != '')
      member = User.find_by(cu_link_id: params[:cu_link_id])
    end
    if member.nil?
      flash[:alert] = 'Member Not Existed'
      redirect_to(action: 'index') and return
    elsif member.activated == false
      flash[:alert] = 'Member Not Activated'
      redirect_to(action: 'index') and return
    end

    @loans = member.individual_loan
    @loan_amount = member.individual_loan_amount
    @loan_amount = 0 if member.individual_loan_amount.nil?
    @cuid = member.cuid
  end

  def create
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    member = User.find_by(cuid: params[:cuid])
    if member.nil?
      flash[:alert] = 'Member Not Existed'
      redirect_to(action: 'index') and return
    elsif member.activated == false
      redirect_to(action: 'index') and return
    end

    if corner_drawdown_loan(current_user, member, params[:amount])
      flash[:success] = 'Loan created successfully'
      redirect_to(action: 'show', cuid: member.cuid) and return
    else
      redirect_to(action: 'show', cuid: member.cuid) and return
    end
  end

  def kill_debt
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    member = User.find_by(cuid: params[:cuid])
    if member.nil?
      flash[:alert] = 'Member Not Existed'
      redirect_to(action: 'index') and return
    elsif member.activated == false
      redirect_to(action: 'index') and return
    end

    loan = Corner::Loan::Loan.find_by_number(params[:loan_no])
    if loan.nil?
      flash[:alert] = 'Loan not found'
      redirect_to(action: 'show', cuid: member.cuid) and return
    elsif loan.status == 2
      flash[:alert] = 'Loan has already repayed'
      redirect_to(action: 'show', cuid: member.cuid) and return
    end

    loan.status = 3
    loan.save
    member.individual_loan_amount -= (loan.amount - loan.repayed_amount)
    member.save

    flash[:success] = 'Loan Kill'
    redirect_to(action: 'index') and return
  end

  def update
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    member = User.find_by(cuid: params[:cuid])
    if member.nil?
      flash[:alert] = 'Member Not Existed'
      redirect_to(action: 'index') and return
    elsif member.activated == false
      redirect_to(action: 'index') and return
    end

    loan = Corner::Loan::Loan.find_by_number(params[:loan_no])
    if loan.nil?
      flash[:alert] = 'Loan not found'
      redirect_to(action: 'show', cuid: member.cuid) and return
    elsif loan.status == 2
      flash[:alert] = 'Loan has already repayed'
      redirect_to(action: 'show', cuid: member.cuid) and return
    end

    amount = params[:amount].to_i

    if corner_repay_loan(current_user, member, loan, amount)
      flash[:success] = 'Loan repayed successfully, please return him/her HKD$' + amount.to_s
      redirect_to(action: 'show', cuid: member.cuid) and return
    else

      redirect_to(action: 'show', cuid: member.cuid) and return
    end
  end
end
