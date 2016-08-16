class Entity
  require 'autoinc'
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc

  field :no,      type: Integer
  increments :no

  ## Currenccy System
  field :credit,             type: Float,   default: 0
  has_many :transactions_sent,     class_name: "Transaction",  inverse_of: :sender
  has_many :transactions_receive,  class_name: "Transaction",  inverse_of: :recipient
  has_many :operated_transaction, class_name: "Transaction", inverse_of: :operator

end


