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
    @account = Bank::Account.find_by_number(params[account_no])
    if @account.is_a? Bank::IndividualAccount
      if not @account.owner.eql? (current_user)
        flash[:alert] = t('error.notauthorized')
        redirect_to(request.referrer || root_path) and return
      end
    elsif @account.is_a? Bank::OrganizationalAccount
      if not @account.authorized_person.exist? (current_user)
        flash[:alert] = t('error.notauthorized')
        redirect_to(request.referrer || root_path) and return
      end
    end
  end
        
end
