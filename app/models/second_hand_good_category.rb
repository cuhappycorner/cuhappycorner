class SecondHandGoodCategory
	include Mongoid::Document
	field :id,	type: String
	field :name,  localize: true
	has_many :type, class_name: "SecondHandGoodType", inverse_of: :category
end