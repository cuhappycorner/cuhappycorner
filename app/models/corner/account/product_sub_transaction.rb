class Corner::Account::ProductSubTransaction
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Token
  extend Enumerize

  token pattern: 'PST-%C%C-%d%d%d-%d%d%d', field_name: :number

  # Credit=Sale, Debit=Purchase (Corner point of view)
  enumerize :flow_type, in: [:credit, :debit]

  belongs_to :product, class_name: 'Corner::Pos::Product', inverse_of: :product_sub_transaction

  field :quantity, type: Integer
  field :unit_credit_price, type: Integer
  field :unit_cash_price, type: Money # Cents

  field :credit_amount, type: Integer
  field :cash_amount, type: Money # Cents

  belongs_to :project, class_name: 'Corner::Account::Project', inverse_of: :product_sub_transaction
  belongs_to :transaction, class_name: 'Corner::Account::PosTransaction', inverse_of: :product_sub_transaction

  field :project_new_money_income, type: Money # Cents
  field :project_new_money_spent, type: Money # Cents

  field :project_new_budget_remained, type: Integer
  field :project_new_income_created, type: Integer

  validate :check_enough_project_budget, on: :create
  before_create :execute_project_accounting

  private
    def check_enough_project_budget
      errors.add(:credit_amount) if (not self.flow_type.credit?) && ((self.project.credit_budget_remained - self.credit_amount) < 0)
    end

    def execute_project_accounting
      if self.flow_type.credit?
        self.project.money_income += self.cash_amount
        self.project.credit_income_created += self.credit_amount
      else
        self.project.credit_budget_remained -= self.credit_amount
        self.project.credit_budget_spent += self.credit_amount
        self.project.money_spent += self.cash_amount
      end
      self.project.save
      self.project_new_money_income = self.project.money_income
      self.project_new_money_spent = self.project.money_spent
      self.project_new_budget_remained = self.project.credit_budget_remained
      self.project_new_income_created = self.project.credit_income_created
    end
end