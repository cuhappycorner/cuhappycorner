module Corner::AccountConcern
  extend ActiveSupport::Concern

  def corner_collect_credit(operator, entity, amount, detail)
    transaction = Corner::Account::Transaction.create(operator: operator)
    credit_transaction = Corner::Account::CreditTransaction.create(operator: operator, creditor: HappyCorner.first.account.first, debitor: entity.account, amount: amount, transaction: transaction, detail: detail)
    if not credit_transaction.valid?
      flash[:error] = credit_transaction.errors.full_messages
      transaction.destroy
      return false
    end
    cash_transaction = Corner::Account::CashTransaction.create(transaction: transaction, flow_type: "credit", amount: 0)
    return transaction
  end

  def corner_pay_credit(operator, entity, amount, detail, project)
    transaction = Corner::Account::GeneralTransaction.create(operator: operator, project: project)
    credit_transaction = Corner::Account::GeneralCreditTransaction.create(operator: operator, creditor: entity.account, debitor: HappyCorner.first.account.first, amount: amount, transaction: transaction, detail: detail, project: project)
    if not credit_transaction.valid?
      flash[:error] = credit_transaction.errors.full_messages
      transaction.destroy
      return false
    end
    cash_transaction = Corner::Account::GeneralCashTransaction.create(transaction: transaction, flow_type: "debit", amount: 0, project: project)
    return transaction
  end
end