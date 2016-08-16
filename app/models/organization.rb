class Organization < Entity
  field :org_identifier,            type: String
  field :name,                      localize: true
  field :infinite_credit,     type: Boolean, default: true     
end