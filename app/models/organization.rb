class Organization < Entity
  has_and_belongs_to_many :committee, class_name: 'User', inverse_of: :organization

  ## Bank System
  has_many :account, class_name: 'Bank::OrganizationalAccount', inverse_of: :owner
end

class HappyCorner < Organization
end
