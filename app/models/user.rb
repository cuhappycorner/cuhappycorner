class User < Entity
  extend Enumerize
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

  ## Contact Information
  field :mobile,             type: String

  ## CU-ER Information
  enumerize :cuid_type, in: [:student, :staff, :alumni, :outside]
  field :cuid,     type: String

  field :cu_link_id, type: String

  field :cu_resident,         type: Boolean, default: false
  belongs_to :major, class_name: "User::Major", inverse_of: :student
  field :year_of_admission,   type: Integer
  field :year_of_graduation,  type: Integer

  ## Personal Information
  field :display_name,       type: String
  field :name,               localize: true
  field :birthday,      type: String
  enumerize :gender, in: [:male, :female, :x]


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

  ## Member System - Activation Module

  ## Activatable
  field :activated_at,         type: Time
  field :activated,            type: Boolean, default: false

  validates :mobile, uniqueness: true, presence: true
  validates :cuid,  uniqueness: true, presence: true
  validates :cu_link_id,  uniqueness: true


  def active_for_authentication? 
    super && activated? 
  end 

  def inactive_message 
    if !activated? 
      :not_activated 
    else 
      super # Use whatever other message 
    end 
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.activated?
      recoverable.errors[:base] << I18n.t("devise.failure.not_activated")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end
end