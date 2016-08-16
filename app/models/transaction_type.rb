class TransactionType
  include Mongoid::Document
  field :id,    type: String
  field :name,  localize: true
  has_many :transaction, class_name: "Transaction", inverse_of: :type
end