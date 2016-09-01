class Entity
  include Mongoid::Document
  field :name, localize: true

  ## Bank System
  has_many :operated_bank_account_record, class_name: "Bank::AccountRecord", inverse_of: :operator

  ## Bank System - Transaction Module
  has_many :operated_bank_transaction, class_name: "Bank::Transaction", inverse_of: :operator

end

