class Corner::Account::Project
  include Mongoid::Document
  include Mongoid::Token

  token pattern: 'PJ-%C%C-%d%d%d', field_name: :number

  field :name, type: String
  field :credit_budget_remained, type: Integer, default: 0
  field :credit_budget_spent, type: Integer, default: 0
  field :credit_income_created, type: Integer, default: 0

  field :money_spent, type: Money, default: 0 # Cents
  field :money_income, type: Money, default: 0 # Cents

  has_many :credit_budget_record, class_name: 'Corner::Account::CreditBudgetRecord', inverse_of: :project

  has_many :transaction, class_name: 'Corner::Account::GeneralTransaction', inverse_of: :project
  has_many :credit_transaction, class_name: 'Corner::Account::GeneralCreditTransaction', inverse_of: :project
  has_many :cash_transaction, class_name: 'Corner::Account::GeneralCashTransaction', inverse_of: :project
  has_many :product_sub_transaction, class_name: 'Corner::Account::ProductSubTransaction', inverse_of: :project

  has_many :related_product, class_name: 'Corner::Pos::Product', inverse_of: :project

  has_and_belongs_to_many :authorized_person, class_name: 'User', inverse_of: :corner_project
end
