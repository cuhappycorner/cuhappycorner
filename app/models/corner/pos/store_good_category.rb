class Corner::Pos::StoreGoodCategory
  include Mongoid::Document
  has_many :item, class_name: "Corner::Pos::StoreGood", inverse_of: :category
  field :order, type: Integer
  field :name, localize: true
end