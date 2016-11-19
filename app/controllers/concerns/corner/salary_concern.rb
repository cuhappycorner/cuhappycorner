module Corner::SalaryConcern
  extend ActiveSupport::Concern

  def corner_distribute_salary(operator, employee, amount, detail)
    project = Corner::Account::Project.find_by(name: 'Salary')

    transaction = Corner::Account::SalaryTransaction.create(operator: operator, project: project)
    unless transaction.valid?
      flash[:error] = transaction.errors.full_messages
      return false
    end

    credit_transaction = Corner::Account::SalaryCreditTransaction.create(operator: operator, amount: amount, debitor: HappyCorner.first.account.first, creditor: employee.account, detail: 'Salary Distribution - ' + detail, project: project, transaction: transaction)
    unless credit_transaction.valid?
      flash[:error] = credit_transaction.errors.full_messages
      transaction.destroy
      return false
    end

    true
  end
end
