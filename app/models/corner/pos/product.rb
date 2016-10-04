class Corner::Pos::Product
  include Mongoid::Document
  include Mongoid::Token

  token :pattern => "PD-%C%C-%d%d%d-%d%d%d", :field_name => :number
  belongs_to :project, class_name: "Corner::Account::Project", inverse_of: :related_product
  has_many :product_sub_transaction, class_name: "Corner::Account::ProductSubTransaction", inverse_of: :product

  field :name, localize: true

  #Corner Point of View
  field :sale_credit_price, type: Integer, default: 0
  field :purchase_credit_price, type: Integer, default: 0

  field :sale_cash_price, type: Money, default: 0
  field :purchase_cash_price, type: Money, default: 0
  # TODO: Adjustment & Discount Feature
  field :barcode, type: String
  field :disabled, type: Boolean, default: false
end