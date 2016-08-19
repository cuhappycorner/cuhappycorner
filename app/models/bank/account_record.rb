class Bank::AccountRecord
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short
  belongs_to :operator, class_name: "Entity", inverse_of: :operated_bank_account_record
  belongs_to :account, class_name: "Bank::Account", inverse_of: :record
end

class Bank::FreezeRecord < Bank::AccountRecord
  field :reason, type: String
end

class Bank::UnfreezeRecord < Bank::AccountRecord
  field :reason, type: String
end

class Bank::CloseRecord < Bank::AccountRecord
  field :reason, type: String
end

class Bank::ReopenRecord < Bank::AccountRecord
  field :reason, type: String
end



