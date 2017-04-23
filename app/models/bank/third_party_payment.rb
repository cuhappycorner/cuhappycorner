class Bank::ThirdPartyPayment
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  belongs_to :application, class_name: 'Doorkeeper::Application', inverse_of: nil
  belongs_to :debitor, class_name: 'Bank::Account', inverse_of: nil
  belongs_to :creditor, class_name: 'Bank::Account', inverse_of: nil
  field :amount, type: Integer
  field :detail, type: String
  field :callback_url, type: String

  field :paid, type: Boolean, default: false

  has_one :transaction, class_name: 'Bank::ThirdPartyTransaction', inverse_of: :payment
end