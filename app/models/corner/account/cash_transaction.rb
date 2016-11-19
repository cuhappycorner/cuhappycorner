class Corner::Account::CashTransaction
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Token
  extend Enumerize

  token pattern: 'CT-%C%C-%d%d%d-%d%d%d', field_name: :number

  belongs_to :transaction, class_name: 'Corner::Account::Transaction', inverse_of: :cash_transaction

  enumerize :flow_type, in: [:credit, :debit]
  field :amount, type: Money # CENTS

  def operator
    self.transaction.operator
  end
end

class Corner::Account::GeneralCashTransaction < Corner::Account::CashTransaction
  belongs_to :project, class_name: 'Corner::Account::Project', inverse_of: :cash_transaction

  field :project_new_money_income, type: Money # Cents
  field :project_new_money_spent, type: Money # Cents

  before_create :execute_project_accounting

  private
    def execute_project_accounting
      self.project.money_income = 0 if self.project.money_income == nil
      self.project.money_spent = 0 if self.project.money_spent == nil
      
      if self.flow_type.credit?
        self.project.money_income += self.amount
      else
        self.project.money_spent += self.amount
      end
      self.project.save
      self.project_new_money_income = self.project.money_income
      self.project_new_money_spent = self.project.money_spent
    end  
end

class Corner::Account::DrawdownLoanCashTransaction < Corner::Account::GeneralCashTransaction
end

class Corner::Account::RepayLoanCashTransaction < Corner::Account::GeneralCashTransaction
end

class Corner::Account::PosCashTransaction < Corner::Account::CashTransaction
end

class Corner::Account::MigrationCashTransaction < Corner::Account::GeneralCashTransaction
end
