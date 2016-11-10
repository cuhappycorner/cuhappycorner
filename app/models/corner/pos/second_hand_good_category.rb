class Corner::Pos::SecondHandGoodCategory
  include Mongoid::Document
  has_many :item, class_name: 'Corner::Pos::SecondHandGood', inverse_of: :category
  field :order, type: Integer
  field :name, localize: true
end
