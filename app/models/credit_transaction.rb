class CreditTransaction < Transaction
  field :credit,	type: Float
  after_create do |credit_transaction|
    credit_transaction.sender.credit -= credit_transaction.credit
    credit_transaction.sender.save
    credit_transaction.recipient.credit += credit_transaction.credit
    credit_transaction.recipient.save
  end
  before_destroy do |credit_transaction|
  	credit_transaction.sender.credit += credit_transaction.credit
    credit_transaction.sender.save
    credit_transaction.recipient.credit -= credit_transaction.credit
    credit_transaction.recipient.save
  end
end