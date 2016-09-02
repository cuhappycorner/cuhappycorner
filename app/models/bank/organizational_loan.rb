class Bank::OrganizationalLoan < Bank::Loan
  
  belongs_to :borrower_account, class_name: "Bank::OrganizationalAccount", inverse_of: :loan
  field :amount, type: Integer, default: 0
  field :no_of_instalment, type: Integer # 1 instalment = 30 days
  field :remark, type: String

  # Status
  field :status, type: Integer, default: 0 #0:Pending, 1:Rejected, 2:Approved, 3:Repaid, 4:Bad debt
  field :flag, type: Integer, default: 0 #0:Normal, 1: Can't Repay Interest, 2: Overdue Loan, 3:Can't Repay Interest+Overdue Loan

  # Decided by Banker
  field :loan_drawdown_date, type: Date
  field :interest_rate, type: Array

  # Record after Loan Drawdown
  field :accumulated_interest, type: Integer, default: 0
  field :oustanding_interest, type: Integer, default: 0
  field :amount_relieved, type: Integer, default: 0
  field :amount_repaid, type: Integer, default: 0

  belongs_to :loan_account, class_name: "Bank::LoanAccount", inverse_of: :loan
  has_many :record, class_name: "Bank::LoanRecord", inverse_of: :loan

  ## Transaction Module
  has_many :transaction, class_name: "Bank::LoanTransaction", inverse_of: :loan
end