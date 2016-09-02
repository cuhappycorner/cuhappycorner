class Bank::AccountRecord
  include Mongoid::Document
  include Mongoid::Token
  include Mongoid::Timestamps::Created::Short

  token :pattern => "AR-%C%C-%C%C%C-%C%C%C-%C%C%C", :field_name => :number

  belongs_to :operator, class_name: "Entity", inverse_of: :operated_bank_account_record
  belongs_to :account, class_name: "Bank::Account", inverse_of: :record
  attr_readonly :operator, :account
end

class Bank::CreateAccountRecord < Bank::AccountRecord

end

class Bank::FreezeAccountRecord < Bank::AccountRecord
  field :reason, type: String
  attr_readonly :reason
end

class Bank::UnfreezeAccountRecord < Bank::AccountRecord
  field :reason, type: String
  attr_readonly :reason
end

class Bank::CloseAccountRecord < Bank::AccountRecord
  field :reason, type: String
  attr_readonly :reason
end

class Bank::ReopenAccountRecord < Bank::AccountRecord
  field :reason, type: String
  attr_readonly :reason
end

## Loan Module
class Bank::LoanRecord < Bank::AccountRecord
  belongs_to :loan, class_name: "Bank::OrganizationalLoan", inverse_of: :record
  attr_readonly :loan
end

class Bank::RequestLoanRecord < Bank::LoanRecord
  field :amount, type: Integer
  field :no_of_instalment, type: Integer # 1 instalment = 30 days
  field :remark, type: String
  attr_readonly :amount, :no_of_instalment, :remark
end

class Bank::ApproveLoanRecord < Bank::LoanRecord
  field :reason, type:String
  field :interest_rate, type: Array
  attr_readonly :reason, :interest_rate
end

class Bank::RejectLoanRecord < Bank::LoanRecord
  field :reason, type: String
  attr_readonly :reason
end

# NOT YET IMPLEMENT
class Bank::RepayInterestRecord < Bank::LoanRecord
  field :interest_repaid, type: Integer
  field :rest_of_interest, type: Integer
end

# NOT YET IMPLEMENT
class Bank::CantRepayInterestRecord < Bank::LoanRecord

end

# NOT YET IMPLEMENT
class Bank::RepayLoanRecord < Bank::LoanRecord
  field :loan_repaid, type: Integer
  field :rest_of_loan, type: Integer
end

# NOT YET IMPLEMENT
class Bank::OverdueLoanRecord < Bank::LoanRecord

end

# NOT YET IMPLEMENT
class Bank::ReliefDebtRecord < Bank::LoanRecord

end

# NOT YET IMPLEMENT
class Bank::AdjustInterestRateRecord < Bank::LoanRecord
  field :reason, type: String
  field :past_interest_rate, type: Array
  field :new_interest_rate, type: Array
end

# NOT YET IMPLEMENT
class Bank::RequestExtendOfInstallmentRecord < Bank::LoanRecord

end

# NOT YET IMPLEMENT
class Bank::ReliefInterestRecord < Bank::LoanRecord

end

# NOT YET IMPLEMENT
class Bank::ExtendNoOfInstallmentRecord < Bank::LoanRecord

end

# NOT YET IMPLEMENT
class Bank::EnforceRepayLoanRecord < Bank::AccountRecord

end

# NOT YET IMPLEMENT
class Bank::BankruptRecord < Bank::AccountRecord

end