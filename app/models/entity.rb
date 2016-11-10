class Entity
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  include Mongoid::Token
  include GlobalID::Identification

  token pattern: 'ID-%C%C-%d%d%d-%d%d%d', field_name: :number

  field :name, localize: true

  ## Bank System
  has_many :operated_bank_account_record, class_name: 'Bank::AccountRecord', inverse_of: :operator

  ## Bank System - Transaction Module
  has_many :operated_bank_transaction, class_name: 'Bank::Transaction', inverse_of: :operator

  ## Corner System - Transaction Module
  has_many :operated_corner_transaction, class_name: 'Corner::Account::Transaction', inverse_of: :operator
end
