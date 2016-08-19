class Bank::Transaction
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  field :amount, type: Integer
  belongs_to :operator, class_name: "Entity", inverse_of: :operated_bank_transaction
  belongs_to :debitor, class_name: "Bank::Account", inverse_of: :debit
  belongs_to :creditor, class_name: "Bank::Account", inverse_of: :credit
  field :debitor_balance, type: Integer
  field :creditor_balance, type: Integer
  field :detail, type: String
end

class Bank::TransferTransaction < Bank::Transaction

end


## Loan Module
class Bank::LoanTransaction < Bank::Transaction
  
end

class Bank::DrawdownLoanTransaction < Bank::LoanTransaction

end

class Bank::RepayInterestTransaction < Bank::LoanTransaction

end

class Bank::RepayLoanTransaction < Bank::LoanTransaction

end

class Bank::ReliefDebtTransaction < Bank::LoanTransaction

end

class Bank::EnforceRepayLoanTransaction < Bank::LoanTransaction

end

class Bank::BankruptTransaction < Bank::LoanTransaction

end

##Distribution Module
class Bank::DistributeTransaction < Bank::Transaction

end