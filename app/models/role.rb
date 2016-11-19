class Role
  include Mongoid::Document
  field :name, type: String # admin (System Admin), shopkeeper, banker
  has_and_belongs_to_many :user, class_name: 'User', inverse_of: :role
  validates :name, uniqueness: true
end
