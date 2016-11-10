module Bank::AccountConcern
  extend ActiveSupport::Concern

  ## Create Bank Account
  def bank_create_loan_account(operator, loan)
    account = Bank::LoanAccount.create(loan: loan)
    unless account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)
    unless record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    account
  end

  def bank_create_time_credit_account(operator)
    account = Bank::TimeCreditAccount.create
    unless account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)
    unless record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    account
  end

  def bank_create_individual_account(operator, owner)
    account = Bank::IndividualAccount.create(owner: owner)
    unless account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)
    unless record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    account
  end

  def bank_create_organizational_account(operator, owner)
    account = Bank::OrganizationalAccount.create(owner: owner)
    unless account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    owner.committee.each do |committee|
      account.authorized_person << committee
    end
    account.save
    unless account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)
    unless record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    account
  end

  def bank_create_distribution_use_account(operator)
    account = Bank::DistributionUseAccount.create
    unless account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)
    unless record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    account
  end

  ## Bank Account Freeze/Close
  def bank_freeze_account(operator, account, freezed_until = nil, reason)
    if account.freezed
      flash[:error] = '' # TODO: translation - Error
      return false
    end
    account.freezed = true
    account.freezed_until = freezed_until
    account.save
    unless account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::FreezeAccountRecord.create(account: account, operator: operator, reason: reason)
    unless record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    record
  end

  def bank_unfreeze_account(operator, account, _freezed_until = nil, reason)
    unless account.freezed
      flash[:error] = '' # TODO: translation - Error
      return false
    end
    account.freezed = false
    account.freezed_until = nil
    account.save
    unless account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::UnfreezeAccountRecord.create(account: account, operator: operator, reason: reason)
    unless record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    record
  end

  def bank_close_account(operator, account, reason)
    if account.closed
      flash[:error] = '' # TODO: translation - Error
      return false
    end
    account.closed = true
    account.save
    unless account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::CloseAccountRecord.create(account: account, operator: operator, reason: reason)
    unless record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    record
  end

  def bank_reopen_account(operator, account, reason)
    unless account.closed
      flash[:error] = '' # TODO: translation - Error
      return false
    end
    account.closed = false
    account.save
    unless account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::ReopenAccountRecord.create(account: account, operator: operator, reason: reason)
    unless record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    record
  end
end
