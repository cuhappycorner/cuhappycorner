class Bank::Account
  include Mongoid::Document
  field :balance, type: Integer, default: 0

  field :freezed, type: Boolean, default: false
  field :freezed_until, type: Date, default: nil
  field :closed, type: Boolean, default: false

  has_many :record, class_name: "Bank::AccountRecord", inverse_of: :account
end


class Bank::TimeCreditAccount < Bank::Account

end

class Bank::OrganizationalAccount < Bank::Account
  belongs_to :owner, class_name: "Organization", inverse_of: :account
  has_and_belongs_to_many :authorized_person, class_name: "User", inverse_of: :organizational_account
end

class Bank::IndividualAccount < Bank::Account
  belongs_to :owner, class_name: "User", inverse_of: :account
end
