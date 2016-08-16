class Transaction
  require 'autoinc'
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc
  belongs_to :type, class_name: "TransactionType", inverse_of: :transaction
  belongs_to :operator,		class_name: "Entity", 	inverse_of: :operated_transaction
  belongs_to :sender, 		class_name: "Entity", 	inverse_of: :transactions_sent
  belongs_to :recipient, 	class_name: "Entity",	inverse_of: :transactions_receive
  field :remark,	type: String
  field :no,      type: Integer
  increments :no
end