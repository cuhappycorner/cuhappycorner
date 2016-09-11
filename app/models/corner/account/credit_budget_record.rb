class Corner::Account::CreditBudgetRecord
  include Mongoid::Document
  include Mongoid::Token
  include Mongoid::Timestamps::Created::Short

  token :pattern => "PB-%C%C-%d%d%d", :field_name => :number

  field :amount, type: Integer
  belongs_to :project, class_name: "Corner::Account::Project", inverse_of: :credit_budget_record

  before_create :execute_project_accounting

  private
    def execute_project_accounting
      self.project.credit_budget_remained += self.amount
      self.project.save
    end  

end