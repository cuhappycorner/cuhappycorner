class Corner::Pos::SecondHandGood < Corner::Pos::Product
  belongs_to :category, class_name: "Corner::Pos::SecondHandGoodCategory", inverse_of: :item
  field :order, type: Integer

  def allow_adjustment
    true
  end
end