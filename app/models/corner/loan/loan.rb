class Corner::Loan::Loan
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Token

  token pattern: 'CL-%C%C-%d%d%d-%d%d%d', field_name: :number

  has_many :transaction, class_name: 'Corner::Account::LoanTransaction', inverse_of: :loan
  belongs_to :member, class_name: 'User', inverse_of: :loan
  field :amount, type: Integer, default: 0
  field :repayed_amount, type: Integer, default: 0
  field :deadline, type: Date
  field :status, type: Integer, default: 1 # 1: approved, 2:fully repayed, 3: bad debt

  before_create :check_loan_limit_exceed
  after_create :increase_loan_limit
  before_destroy :decrease_loan_limit

  private
    def check_loan_limit_exceed
      self.member.individual_loan_amount = 0 if self.member.individual_loan_amount == nil
      self.member.save
      errors.add(:amount, ": Loan Limit Exceeded") if self.member.individual_loan_amount + self.amount > 300
    end

    def increase_loan_limit
      self.member.individual_loan_amount += self.amount
      self.member.save
    end

    def decrease_loan_limit
      self.member.individual_loan_amount -= self.amount
      self.member.save
    end

end