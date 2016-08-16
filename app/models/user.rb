class User < Entity
  rolify
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

  ## Customized
  field :gender,             type: String
  field :mobile,             type: String
  field :display_name,       type: String,  default: ""
  field :date_of_birth,      type: String
  field :name,               type: String
  field :chi_name,           type: String
  field :cu_identity,        type: String
  field :cu_identity_no,     type: String
  field :cu_card_id,         type: String,  default: ""
  field :major,              type: String,  default: ""
  field :year_of_admission,  type: Integer, default: 0
  field :year_of_graduation, type: Integer, default: 0
  field :cu_resident,        type: Boolean, default: false

  ## Activation
  field :activated_at,         type: Date
  field :activated,            type: Boolean, default: false
  field :expired,              type: Boolean, default: false
  field :expire_at,            type: Date

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  
  # validates :gender, presense: true, inclusion: { in: [ "male", "female", "x" ] }
  # validates :date_of_birth, presence: true
  validates :mobile, uniqueness: true, presence: true
  validates :cu_identity_no,  uniqueness: true, presence: true

  after_create do |document|
    @cucoop = Organization.find_by(org_identifier: "cucoop")
    @type = TransactionType.find_by(id: "system")
    CreditTransaction.create(operator: @cucoop, sender: @cucoop, recipient: document, type: @type, credit: 20,remark: "New Member 新社員")
  end
  before_destroy do |document|
    if document.credit > 0 
      @cucoop = Organization.find_by(org_identifier: "cucoop")
      @type = TransactionType.find_by(id: "system")
      CreditTransaction.create(operator: @cucoop, sender: document, recipient: @cucoop, type: @type, credit: document.credit,remark: "Delete Member 刪除社員")
    end
  end
end