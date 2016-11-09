class Corner::Pos::StoreGood < Corner::Pos::Product
  belongs_to :category, class_name: "Corner::Pos::StoreGoodCategory", inverse_of: :item
  field :order, type: Integer

  def allow_adjustment
    true
  end
end