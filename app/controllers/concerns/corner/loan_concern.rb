module Corner::LoanConcern
  extend ActiveSupport::Concern

  def corner_drawdown_loan(operator, member, amount)
    loan = Corner::Loan::Loan.create(member: member, amount: amount, deadline: 90.days.from_now)
    unless loan.valid?
      flash[:error] = loan.errors.full_messages
      return false
    end
    project = Corner::Account::Project.find_by(name: 'Individual Loan')

    transaction = Corner::Account::DrawdownLoanTransaction.create(operator: operator, loan: loan, project: project)
    unless transaction.valid?
      flash[:error] = transaction.errors.full_messages
      loan.destroy
      return false
    end

    credit_transaction = Corner::Account::DrawdownLoanCreditTransaction.create(operator: operator, amount: amount, debitor: HappyCorner.first.account.first, creditor: member.account, detail: 'Individual Loan Drawdown', project: project, transaction: transaction) # change detail
    unless credit_transaction.valid?
      flash[:error] = credit_transaction.errors.full_messages
      loan.destroy
      transaction.destroy
      return false
    end

    cash_transaction = Corner::Account::DrawdownLoanCashTransaction.create(flow_type: 'credit', amount: amount, transaction: transaction, project: project)
    unless cash_transaction.valid?
      flash[:error] = cash_transaction.errors.full_messages
      return false
    end
    true
  end

  def corner_repay_loan(operator, member, loan, amount)
    loan.repayed_amount = 0 if loan.repayed_amount.nil?
    loan.save
    if amount > loan.amount - loan.repayed_amount
      flash[:error] = 'Amount > Amount needed'
      return false
    elsif member.account.balance < amount
      flash[:error] = 'Account Balance Not Enough'
      return false
    end

    project = Corner::Account::Project.find_by(name: 'Individual Loan')
    transaction = Corner::Account::RepayLoanTransaction.create(operator: operator, loan: loan, project: project)
    unless transaction.valid?
      flash[:error] = transaction.errors.full_messages
      return false
    end

    credit_transaction = Corner::Account::RepayLoanCreditTransaction.create(operator: operator, amount: amount, debitor: member.account, creditor: HappyCorner.first.account.first, detail: 'Individual Loan Repayment', project: project, transaction: transaction) # change detail
    unless credit_transaction.valid?
      flash[:error] = credit_transaction.errors.full_messages
      return false
    end

    cash_transaction = Corner::Account::RepayLoanCashTransaction.create(flow_type: 'debit', amount: amount, transaction: transaction, project: project)
    unless cash_transaction.valid?
      flash[:error] = cash_transaction.errors.full_messages
      return false
    end

    loan.repayed_amount = loan.repayed_amount + amount
    loan.save

    member.individual_loan_amount -= amount
    member.save

    if loan.repayed_amount >= loan.amount
      loan.status = 2
      loan.save
    end
    true
  end
end
