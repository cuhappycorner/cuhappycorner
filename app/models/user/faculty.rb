class User::Faculty
  include Mongoid::Document
  field :order, type: Integer
  field :name, localize: true
  has_many :major, class_name:"User::Major", inverse_of: :faculty
end