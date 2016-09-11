class Corner::Account::Transaction
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Token
  extend Enumerize

  token :pattern => "TR-%C%C-%d%d%d-%d%d%d", :field_name => :number

  belongs_to :operator, class_name: "Entity", inverse_of: :operated_corner_transaction

  has_one :credit_transaction, class_name: "Corner::Account::CreditTransaction", inverse_of: :transaction
  has_one :cash_transaction, class_name: "Corner::Account::CashTransaction", inverse_of: :transaction
end

class Corner::Account::GeneralTransaction < Corner::Account::Transaction
  belongs_to :project, class_name: "Corner::Account::Project", inverse_of: :transaction
end

class Corner::Account::MigrationTransaction < Corner::Account::GeneralTransaction

end

class Corner::Account::LoanTransaction < Corner::Account::GeneralTransaction
  belongs_to :loan, class_name: "Corner::Loan::Loan", inverse_of: :transaction
end

class Corner::Account::DrawdownLoanTransaction < Corner::Account::LoanTransaction

end

class Corner::Account::RepayLoanTransaction < Corner::Account::LoanTransaction

end

class Corner::Account::PosTransaction < Corner::Account::Transaction
  has_many :product_sub_transaction, class_name: "Corner::Account::ProductSubTransaction", inverse_of: :transaction
end