class Bank::Loan
  include Mongoid::Document
  include Mongoid::Token

  token :pattern => "LO-%C%C-%C%C%C-%C%C%C-%C%C%C", :field_name => :number
end