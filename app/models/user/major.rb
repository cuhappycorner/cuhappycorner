class User::Major
  include Mongoid::Document
  belongs_to :faculty, class_name: "User::Faculty", inverse_of: :major
  field :code, type: String
  field :name, localize: true
  has_many :student, class_name:"User", inverse_of: :major
end