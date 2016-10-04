class Bank::Transaction
  include Mongoid::Document
  include Mongoid::Token
  include Mongoid::Timestamps::Created::Short

  token :pattern => "TS-%C%C-%C%C%C-%C%C%C-%C%C%C", :field_name => :number

  field :amount, type: Integer
  belongs_to :operator, class_name: "Entity", inverse_of: :operated_bank_transaction
  belongs_to :debitor, class_name: "Bank::Account", inverse_of: :debit
  belongs_to :creditor, class_name: "Bank::Account", inverse_of: :credit
  field :debitor_new_balance, type: Integer
  field :creditor_new_balance, type: Integer
  field :detail, type: String

  # attr_readonly :amount, :operator, :debitor, :creditor, :debitor_new_balance, :creditor_new_balance, :detail

  validates :amount, numericality: { :greater_than => 0}

  validate :check_enough_balance, on: :create

  before_create :execute_transaction

  private
    def check_enough_balance
      errors.add(:amount, "") if (not self.debitor.allow_negative) && ((self.debitor.balance - amount) < 0)
      errors.add(:amount, "") if (not self.creditor.allow_positive) && ((self.creditor.balance + self.amount) > 0)
    end

    def execute_transaction
      self.debitor.balance -= self.amount
      self.debitor.save
      self.creditor.balance += self.amount
      self.creditor.save
      self.debitor_new_balance = self.debitor.balance
      self.creditor_new_balance = self.creditor.balance
    end

end

class Bank::TransferTransaction < Bank::Transaction

end


## Loan Module
class Bank::LoanTransaction < Bank::Transaction
  belongs_to :loan, class_name: "Bank::OrganizationalLoan", inverse_of: :transaction
  # attr_readonly :loan
end

class Bank::DrawdownLoanTransaction < Bank::LoanTransaction

end

class Bank::RepayInterestTransaction < Bank::LoanTransaction
  # TODO
end

class Bank::RepayLoanTransaction < Bank::LoanTransaction
  # TODO
end

class Bank::ReliefDebtTransaction < Bank::LoanTransaction
  # TODO
end

class Bank::EnforceRepayLoanTransaction < Bank::LoanTransaction
  # TODO
end

class Bank::BankruptTransaction < Bank::LoanTransaction
  # TODO
end

##Distribution Module
class Bank::DistributeTransaction < Bank::Transaction
  # TODO
end