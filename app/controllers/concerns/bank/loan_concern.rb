module Bank::LoanConcern
  extend ActiveSupport::Concern

  ## Bank System - Loan Module
  def bank_request_loan(operator, account, amount, no_of_instalment, remark)
    loan = Bank::OrganizationalLoan.create(borrower_account: account, amount: amount, no_of_instalment: no_of_instalment, remark: remark)
    if not loan.valid?
      flash[:error] = loan.errors.full_messages
      return false
    end

    record = Bank::RequestLoanRecord.create(account: account, operator: operator, amount: amount, no_of_instalment: no_of_instalment, remark: remark, loan: loan)
    if not record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    return loan
  end

  def bank_approve_loan(operator, loan, interest_rate, reason)
    bank_create_loan_account(operator, loan)
    loan.interest_rate = interest_rate
    loan.status = 2
    loan.loan_drawdown_date = Time.now
    loan.save
    if not loan.valid?
      flash[:error] = loan.errors.full_messages
      return false
    end
    
    # TODO: FILL DETAIL
    transaction = Bank::DrawdownLoanTransaction.create(amount: loan.amount, operator: operator, debitor: loan.loan_account, creditor: loan.borrower_account, detail: "TO BE FILLED", loan: loan)
    if not transaction.valid?
      flash[:error] = transaction.errors.full_messages
      return false
    end

    record = Bank::ApproveLoanRecord.create(account: loan.borrower_account, operator: operator, loan: loan, reason: reason, interest_rate: interest_rate)
    if not record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    return record
  end

  def bank_reject_loan(operator, loan, reason)
    loan.status = 1
    loan.save
    if not loan.valid?
      flash[:error] = loan.errors.full_messages
      return false
    end

    record = Bank::RejectLoanRecord.create(account: loan.borrower_account, operator: operator, loan: loan, reason: reason)
    if not record.valid?
      flash[:error] = record.errors.full_messages
      return false
    end

    return record
  end

end