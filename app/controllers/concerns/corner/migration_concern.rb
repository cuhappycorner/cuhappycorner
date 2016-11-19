module Corner::MigrationConcern
  extend ActiveSupport::Concern

  def corner_migrate(member, amount)
    project = Corner::Account::Project.find_by(name: '2016 Sep System Migration')
    operator = User.find_by(cuid: '1155048299')

    transaction = Corner::Account::MigrationTransaction.create(operator: operator, project: project)
    return false unless transaction.valid?

    credit_transaction = Corner::Account::MigrationCreditTransaction.create(operator: operator, amount: amount, debitor: HappyCorner.first.account.first, creditor: member.account, detail: 'Add Back HappyCoins from Old System', project: project, transaction: transaction) # change detail
    unless credit_transaction.valid?
      transaction.destroy
      return false
    end

    cash_transaction = Corner::Account::MigrationCashTransaction.create(flow_type: 'credit', amount: Money.new(0, 'HKD'), transaction: transaction, project: project)
    unless cash_transaction.valid?
      flash[:error] = cash_transaction.errors.full_messages
      return false
    end
    true
  end
end
