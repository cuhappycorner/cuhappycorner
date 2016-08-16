class TransactSecondHandGood
	include Mongoid::Document
	field :price, type: Float
	field :quantity, type: Integer
	field :buy_sell, type: String
	belongs_to :type, class_name: "SecondHandGoodType", inverse_of: :transact_good
	belongs_to :transaction,	class_name: "SecondHandGoodTransaction", inverse_of: :good
end