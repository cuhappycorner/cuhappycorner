class Role
  include Mongoid::Document
  field :name, type: String
  has_and_belongs_to_many :user, class_name: "User", inverse_of: :role

end