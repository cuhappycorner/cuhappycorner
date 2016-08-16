class SecondHandGoodType
	include Mongoid::Document
	field :id,	type: String
	field :name,  localize: true
	field :default_buying_price,	type: Float
	field :default_selling_price,	type: Float
	belongs_to :category,		class_name: "SecondHandGoodCategory", 	inverse_of: :operated_transaction
	has_many :transact_good,	class_name: "SecondHandGoodTransaction",	inverse_of: :type
end