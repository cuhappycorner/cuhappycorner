class Bank::Loan
  include Mongoid::Document
  include Mongoid::Token

  token :pattern => "LO-%C%C-%d%d%d-%d%d%d", :field_name => :number
end