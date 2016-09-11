require File.expand_path("../../../config/environment", __FILE__)

corner = HappyCorner.new
corner.name = "CU Happy Corner"
corner.save

proj1 = Corner::Account::Project.new
proj1.name = "2016 Sep System Migration"
proj1.save

proj2 = Corner::Account::Project.new
proj2.name = "Individual Loan"
proj2.save

proj3 = Corner::Account::Project.new
proj3.name = "Second Hand Goods"
proj3.save

good1 = Corner::Pos::SemStartMarketGood.create(project: proj3, name: "Group 1 Item - SemStart Market", sale_credit_price: 3)
good2 = Corner::Pos::SemStartMarketGood.create(project: proj3, name: "Group 2 Item - SemStart Market", sale_credit_price: 5)
good3 = Corner::Pos::SemStartMarketGood.create(project: proj3, name: "Group 3 Item - SemStart Market", sale_credit_price: 10)
good4 = Corner::Pos::SemStartMarketGood.create(project: proj3, name: "Group 4 Item - SemStart Market", sale_credit_price: 20)

record1 = Corner::Account::CreditBudgetRecord.create(project: b, amount: 10000)
