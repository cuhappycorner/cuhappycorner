class SecondHandGoodTransaction < CreditTransaction
	has_many :good,		class_name: "TransactSecondHandGood", 	inverse_of: :transaction
end

