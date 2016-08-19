module Bank
  extend ActiveSupport::Concern

  ## Create Bank Account
  def bank_create_loan_account(operator, loan)
    account = Bank::LoanAccount.create()
    account.loan = loan
    account.save

    record = Bank::CreateAccountRecord.create()
    record.account = account
    record.operator = operator
    record.save

    return account
  end

  def bank_create_time_credit_account(operator)
    account = Bank::TimeCreditAccount.create()

    record = Bank::CreateAccountRecord.create()
    record.account = account
    record.operator = operator
    record.save

    return account
  end

  def bank_create_individual_account(operator, owner)
    account = Bank::IndividualAccount.create()
    account.owner = owner
    account.save

    record = Bank::CreateAccountRecord.create()
    record.account = account
    record.operator = operator
    record.save

    return account
  end

  def bank_create_organizational_account(operator, owner)
    account = Bank::OrganizationalAccount.create()
    account.owner = owner
    owner.committee.each do |committee|
      account.authorized_person << committee
    end

    record = Bank::CreateAccountRecord.create()
    record.account = account
    record.operator = operator
    record.save

    return account
  end

  def bank_create_distribution_use_account(operator)
    account = Bank::DistributionUseAccount.create()

    record = Bank::CreateAccountRecord.create()
    record.account = account
    record.operator = operator
    record.save

    return account
  end

  ## Bank Account Freeze/Close
  def bank_freeze_account(operator, account, freezed_until=nil, reason)
    if account.freezed
      return nil
    end
    account.freezed = true
    account.freezed_until = freezed_until
    account.save

    record = Bank::FreezeAccountRecord.create()
    record.operator = operator
    record.reason = reason
    record.save

    return record
  end

  def bank_unfreeze_account(operator, account, freezed_until=nil, reason)
    if !account.freezed
      return nil
    end
    account.freezed = false
    account.freezed_until = nil
    account.save

    record = Bank::UnfreezeAccountRecord.create()
    record.operator = operator
    record.reason = reason
    record.save

    return record
  end

  def bank_close_account(operator, account, reason)
    if account.closed
      return nil
    end
    account.closed = true
    account.save

    record = Bank::CloseAccountRecord.create()
    record.operator = operator
    record.reason = reason
    record.save

    return record
  end

  def bank_reopen_account(operator, account, reason)
    if !account.closed
      return nil
    end
    account.closed = false
    account.save

    record = Bank::ReopenAccountRecord.create()
    record.operator = operator
    record.reason = reason
    record.save

    return record
  end


end