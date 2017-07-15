class Corner::Pos::SecondHandGood < Corner::Pos::Product
  belongs_to :category, class_name: 'Corner::Pos::SecondHandGoodCategory', inverse_of: :item
  field :order, type: Integer
  field :disabled, type: Boolean, default: false

  def allow_adjustment
    true
  end
end
