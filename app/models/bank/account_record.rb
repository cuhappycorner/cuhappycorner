class Bank::AccountRecord
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  belongs_to :operator, class_name: "Entity", inverse_of: :operated_bank_account_record
  belongs_to :account, class_name: "Bank::Account", inverse_of: :record
end

class Bank::FreezeRecord < Bank::AccountRecord
  field :reason, type: String
end

class Bank::UnfreezeRecord < Bank::AccountRecord
  field :reason, type: String
end

class Bank::CloseRecord < Bank::AccountRecord
  field :reason, type: String
end

class Bank::ReopenRecord < Bank::AccountRecord
  field :reason, type: String
end

## Loan Module
class Bank::LoanRecord < Bank::AccountRecord
  belongs_to :loan, class_name: "Bank::OrganizationalLoan", inverse_of: :record
end

class Bank::RequestLoanRecord < Bank::LoanRecord
  field :amount, type: Integer

end

class Bank::ApproveLoanRecord < Bank::LoanRecord
  field :reason, type:String
  field :interest_rate, type: Array
  field :no_of_instalment, type: Integer # 1 instalment = 30 days
end

class Bank::RejectLoanRecord < Bank::LoanRecord
  field :reason, type: String
end

class Bank::RepayInterestRecord < Bank::LoanRecord
  field :interest_repaid, type: Integer
  field :rest_of_interest, type: Integer
end

class Bank::CantRepayInterestRecord < Bank::LoanRecord

end

class Bank::RepayLoanRecord < Bank::LoanRecord
  field :loan_repaid, type: Integer
  field :rest_of_loan, type: Integer
end

class Bank::OverdueLoanRecord < Bank::LoanRecord

end

class Bank::ReliefDebtRecord < Bank::LoanRecord

end

class Bank::AdjustInterestRateRecord < Bank::LoanRecord
  field :reason, type: String
end

class Bank::RequestExtendOfInstallmentRecord < Bank::LoanRecord

end

class Bank::ReliefInterestRecord < Bank::LoanRecord

end

class Bank::ExtendNoOfInstallmentRecord < Bank::LoanRecord

end

class Bank::BankruptRecord < Bank::AccountRecord
end
