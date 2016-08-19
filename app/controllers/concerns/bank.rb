module Bank
  extend ActiveSupport::Concern

  ## Create Bank Account
  def bank_create_loan_account(operator, loan)
    account = Bank::LoanAccount.create(loan: loan)

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)

    return account
  end

  def bank_create_time_credit_account(operator)
    account = Bank::TimeCreditAccount.create()

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)

    return account
  end

  def bank_create_individual_account(operator, owner)
    account = Bank::IndividualAccount.create(owner: owner)


    record = Bank::CreateAccountRecord.create(account: account, operator: operator)

    return account
  end

  def bank_create_organizational_account(operator, owner)
    account = Bank::OrganizationalAccount.create(owner: owner)
    owner.committee.each do |committee|
      account.authorized_person << committee
    end
    account.save

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)

    return account
  end

  def bank_create_distribution_use_account(operator)
    account = Bank::DistributionUseAccount.create()

    record = Bank::CreateAccountRecord.create(account: account, operator: operator)

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

    record = Bank::FreezeAccountRecord.create(account: account, operator: operator, reason: reason)

    return record
  end

  def bank_unfreeze_account(operator, account, freezed_until=nil, reason)
    if !account.freezed
      return nil
    end
    account.freezed = false
    account.freezed_until = nil
    account.save

    record = Bank::UnfreezeAccountRecord.create(account: account, operator: operator, reason: reason)

    return record
  end

  def bank_close_account(operator, account, reason)
    if account.closed
      return nil
    end
    account.closed = true
    account.save

    record = Bank::CloseAccountRecord.create(account: account, operator: operator, reason: reason)

    return record
  end

  def bank_reopen_account(operator, account, reason)
    if !account.closed
      return nil
    end
    account.closed = false
    account.save

    record = Bank::ReopenAccountRecord.create(account: account, operator: operator, reason: reason)

    return record
  end

  ## Bank System - Loan Module
  def bank_request_loan(operator, account, amount, no_of_instalment, remark)
    loan = Bank::OrganizationalLoan.create(borrower_account: account, amount: amount, no_of_instalment: no_of_instalment, remark: remark)

    record = Bank::RequestLoanRecord.create(account: account, operator: operator, amount: amount, no_of_instalment: no_of_instalment, remark: remark)

    return loan
  end

  def bank_approve_loan(operator, loan, interest_rate, reason)
    bank_create_loan_account(operator, loan)
    loan.interest_rate = interest_rate
    loan.status = 2
    loan.loan_drawdown_date = Time.now
    loan.save
    
    # TODO: FILL DETAIL
    Bank::DrawdownLoanTransaction.create(amount: loan.amount, operator: operator, debitor: loan.loan_account, creditor: loan.borrower_account, detail: "TO BE FILLED", loan: loan)

    record = Bank::ApproveLoanRecord.create(account: loan.borrower_account, operator: operator, loan: loan, reason: reason, interest_rate: interest_rate)

    return record
  end

  def bank_reject_loan(operator, loan, reason)
    loan.status = 1
    loan.save

    record = Bank::RejectLoanRecord.create(account: loan.borrower_account, operator: operator, loan: loan, reason: reason)

    return record
  end

end