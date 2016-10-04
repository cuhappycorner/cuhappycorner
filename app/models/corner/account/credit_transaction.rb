class Corner::Account::CreditTransaction < Bank::Transaction
  belongs_to :transaction, class_name: "Corner::Account::Transaction", inverse_of: :credit_transaction
end

class Corner::Account::GeneralCreditTransaction < Corner::Account::CreditTransaction
  belongs_to :project, class_name: "Corner::Account::Project", inverse_of: :credit_transaction
  field :project_new_budget_remained, type: Integer
  field :project_new_income_created, type: Integer

  validate :check_enough_project_budget, on: :create

  before_create :execute_project_accounting

  private
    def check_enough_project_budget
      errors.add(:amount, "") if (self.debitor.owner.is_a? (HappyCorner)) && ((self.project.credit_budget_remained - self.amount) < 0)
    end

    def execute_project_accounting
      if (self.debitor.owner.is_a? (HappyCorner))
        self.project.credit_budget_remained = 0 if self.project.credit_budget_remained == nil
        self.project.credit_budget_spent = 0 if self.project.credit_budget_spent == nil
        self.project.credit_budget_remained -= self.amount
        self.project.credit_budget_spent += self.amount
      elsif (self.creditor.owner.is_a? (HappyCorner))
        self.project.credit_income_created = 0 if self.project.credit_income_created == nil
        self.project.credit_income_created += self.amount
      end
      self.project.save
      self.project_new_budget_remained = self.project.credit_budget_remained
      self.project_new_income_created = self.project.credit_income_created
    end
end

class Corner::Account::MigrationCreditTransaction < Corner::Account::GeneralCreditTransaction

end


class Corner::Account::DrawdownLoanCreditTransaction < Corner::Account::GeneralCreditTransaction

end

class Corner::Account::RepayLoanCreditTransaction < Corner::Account::GeneralCreditTransaction

end

class Corner::Account::PosCreditTransaction < Corner::Account::CreditTransaction
  
end