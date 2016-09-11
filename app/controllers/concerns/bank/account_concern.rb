module Bank::AccountConcern
  extend ActiveSupport::Concern

  ## Create Bank Account
  def bank_create_loan_account(operator, loan)
    account = Bank::LoanAccount.create(loan: loan)
    if not account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)
    if not record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    return account
  end

  def bank_create_time_credit_account(operator)
    account = Bank::TimeCreditAccount.create()
    if not account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)
    if not record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    return account
  end

  def bank_create_individual_account(operator, owner)
    account = Bank::IndividualAccount.create(owner: owner)
    if not account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)
    if not record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    return account
  end

  def bank_create_organizational_account(operator, owner)
    account = Bank::OrganizationalAccount.create(owner: owner)
    if not account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    owner.committee.each do |committee|
      account.authorized_person << committee
    end
    account.save
    if not account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)
    if not record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    return account
  end

  def bank_create_distribution_use_account(operator)
    account = Bank::DistributionUseAccount.create()
    if not account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)
    if not record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    return account
  end

  ## Bank Account Freeze/Close
  def bank_freeze_account(operator, account, freezed_until=nil, reason)
    if account.freezed
      flash[:error] = "" # TODO: translation - Error
      return false
    end
    account.freezed = true
    account.freezed_until = freezed_until
    account.save
    if not account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::FreezeAccountRecord.create(account: account, operator: operator, reason: reason)
    if not record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    return record
  end

  def bank_unfreeze_account(operator, account, freezed_until=nil, reason)
    if !account.freezed
      flash[:error] = "" # TODO: translation - Error
      return false
    end
    account.freezed = false
    account.freezed_until = nil
    account.save
    if not account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::UnfreezeAccountRecord.create(account: account, operator: operator, reason: reason)
    if not record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    return record
  end

  def bank_close_account(operator, account, reason)
    if account.closed
      flash[:error] = "" # TODO: translation - Error
      return false
    end
    account.closed = true
    account.save
    if not account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::CloseAccountRecord.create(account: account, operator: operator, reason: reason)
    if not record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    return record
  end

  def bank_reopen_account(operator, account, reason)
    if !account.closed
      flash[:error] = "" # TODO: translation - Error
      return false
    end
    account.closed = false
    account.save
    if not account.valid?
      flash[:error] = account.errors.full_messages
      return false
    end

    record = Bank::ReopenAccountRecord.create(account: account, operator: operator, reason: reason)
    if not record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    return record
  end

end