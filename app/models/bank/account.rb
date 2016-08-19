class Bank::Account
  include Mongoid::Document
  field :balance, type: Integer, default: 0

  ## Transaction Module
  has_many :debit, class_name: "Bank::Transaction", inverse_of: :debitor #expense
  has_many :credit, class_name: "Bank::Transaction", inverse_of: :creditor #income

  field :freezed, type: Boolean, default: false
  field :freezed_until, type: Date, default: nil
  field :closed, type: Boolean, default: false

  has_many :record, class_name: "Bank::AccountRecord", inverse_of: :account
end

## Loan Module
class Bank::LoanAccount < Bank::Account
  has_one :loan, class_name: "Bank::OrganizationalLoan", inverse_of: :loan_account
end

class Bank::TimeCreditAccount < Bank::Account

end

class Bank::OrganizationalAccount < Bank::Account
  belongs_to :owner, class_name: "Organization", inverse_of: :account
  has_and_belongs_to_many :authorized_person, class_name: "User", inverse_of: :organizational_account

  ## Loan Module
  has_many :loan, class_name: "Bank::OrganizationalLoan", inverse_of: :borrower_account

end

class Bank::IndividualAccount < Bank::Account
  belongs_to :owner, class_name: "User", inverse_of: :account
end

## Loan Module
class Bank::DistributionUseAccount < Bank::Account

end