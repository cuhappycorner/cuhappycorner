class User::Major
  include Mongoid::Document
  field :code, type: String
  field :name, localize: true
  has_many :student, class_name:"User", inverse_of: :major
end