class Entity
  include Mongoid::Document
  field :name, localize: true

  ## Bank System
  has_many :operated_bank_account_record, class_name: "Bank::AccountRecord", inverse_of: :operator

end

class User < Entity
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  has_and_belongs_to_many :organization, class_name: "Organization", inverse_of: :committee

  ## Bank System
  has_one :account, class_name: "Bank::IndividualAccount", inverse_of: :owner
  has_and_belongs_to_many :organizational_account, class_name: "Bank::OrganizationalAccount", inverse_of: :authorized_person
end

class Organization < Entity
  has_and_belongs_to_many :committee, class_name: "User", inverse_of: :organization

  ## Bank System
  has_many :account, class_name: "Bank::OrganizationalAccount", inverse_of: :owner
end

class Computer < Entity

end