class Bank::AccountController < ApplicationController
  include Bank::LoanConcern

  before_action :authenticate_user!

  # GET
  def index
    @account = current_user.account
    @organizational_accounts = current_user.organizational_account
  end

  # GET
  def show
    @account = Bank::Account.find_by_number(params[:account_no])
    unless (current_user.role.include? Role.find_by(name: 'shopkeeper'))
      if @account.is_a? Bank::IndividualAccount
        unless @account.owner.eql? current_user
          flash[:alert] = t('error.notauthorized')
          redirect_to(request.referrer || root_path) and return
        end
      elsif @account.is_a? Bank::OrganizationalAccount
        unless @account.authorized_person.where(id: current_user.id).exists?
          flash[:alert] = t('error.notauthorized')
          redirect_to(request.referrer || root_path) and return
        end
      end
    end
    @transactions = Bank::Transaction.or({debitor: @account}, {creditor: @account}).all
  end
end