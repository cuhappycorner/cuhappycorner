class Bank::TransferController < ApplicationController
  include Bank::LoanConcern

  before_action :authenticate_user!

  # GET
  def index
    @account = current_user.account
    @organizational_accounts = current_user.organizational_account
  end

  # GET
  def transfer
    sender = Bank::Account.find_by_number(params[:sender_account_no])
    if sender.nil?
      flash[:alert] = "Sender Account Error"
      redirect_to(action: 'index') and return
    elsif sender.is_a? Bank::IndividualAccount
      unless sender.owner.eql? current_user
        flash[:alert] = t('error.notauthorized')
        redirect_to(request.referrer || root_path) and return
      end
    elsif sender.is_a? Bank::OrganizationalAccount
      unless sender.authorized_person.where(id: current_user.id).exists?
        flash[:alert] = t('error.notauthorized')
        redirect_to(request.referrer || root_path) and return
      end
    end

    recipient = Bank::Account.find_by_number(params[:recipient_account_no])
    if recipient.nil?
      flash[:alert] = "Recipient Account Error"
      redirect_to(action: 'index') and return
    end
    unless (recipient.is_a? Bank::IndividualAccount) || (recipient.is_a? Bank::OrganizationalAccount)
      flash[:alert] = "Recipient Account Error"
      redirect_to(action: 'index') and return
    end

    if params[:recipient_account_no] == params[:sender_account_no]
      flash[:alert] = "Sender and Recipient cannot be the same."
      redirect_to(action: 'index') and return
    end
    
    transaction = Bank::TransferTransaction.create(operator: current_user, creditor: recipient, debitor: sender, amount: params[:amount].to_i, detail: params[:detail])
    unless transaction.valid?
      flash[:error] = transaction.errors.full_messages
      redirect_to(action: 'index') and return
    end
    flash[:success] = 'Transfer succeed. Sender\'s Credit Remained: ' + sender.balance.to_s + '. Ref. No. ' + transaction.number
    redirect_to(action: 'index') and return
  end

  def get_sender_info
    ok = false
    name = '-'
    type = '-'
    balance = 0
    account = Bank::Account.find_by_number(params[:account_no])
    if account.is_a? Bank::IndividualAccount
      if account.owner.eql? current_user
        name = account.owner.name
        type = 'Individual Account'
        balance = account.balance
        ok = true
      end
    elsif account.is_a? Bank::OrganizationalAccount
      if account.authorized_person.where(id: current_user.id).exists?
        name = account.owner.name
        type = 'Organizational Account'
        balance = account.balance
        ok = true
      end
    end
    @status = { ok: ok, name: name, type: type, balance: balance}
    render json: @status
  end

  def get_recipient_info
    ok = false
    entity = nil
    acc_no = '-'
    type = '-'
    name = 'Not Found'
    if params[:cuid].present?
      entity = User.find_by(cuid: params[:cuid])
      unless entity.nil?
        if entity.activated
          name = entity.name.gsub(/\B[\p{Han}|\w]/,'*')
          ok = true
          acc_no = entity.account.number
          type = 'Individual Account'
        else
          name = 'Not Activated'
        end
      end
    elsif params[:ac_no].present?
      entity = Bank::Account.find_by(number: params[:ac_no]).try(:owner)
      unless entity.nil?
        ok = true
        acc_no = params[:ac_no]
        if entity.is_a? Organization
          type = 'Organizational Account'
          name = entity.name
        else
          type = 'Individual Account'
          name = entity.name.gsub(/\B[\p{Han}|\w]/,'*')
        end
      end
    end
    @status = { ok: ok, name: name, type: type, acc_no: acc_no}
    render json: @status
  end
end
