class DailyStatsToGlipJob < ActiveJob::Base
  def perform
    require 'glip_poster'
    date = Time.zone.today

    user_today = User.where('$and' => [{:created_at => {:$gte => date}}, {:created_at => {:$lte => date+1}}]).count
    user = User.count
    activated_user_today = User.where('$and' => [{:created_at => {:$gte => date}}, {:created_at => {:$lte => date+1}}]).count
    activated_user = User.where(activated: true).count
    # transaction_no_today = 
    # transaction_no = 
    # transaction_amount_today = 
    # transaction_amount = 
    transactions = Corner::Account::PosTransaction.all
    transactions_today = Corner::Account::PosTransaction.where('$and' => [{:created_at => {:$gte => date}}, {:created_at => {:$lte => date+1}}])
    second_hand_transaction = transactions.select{ |t| t&.product_sub_transaction&.first&.project&.name == "Second Hand Goods"}
    second_hand_transaction_today = transactions_today.select{ |t| t&.product_sub_transaction&.first&.project&.name == "Second Hand Goods"}
    second_hand_transaction_in = second_hand_transaction.select{ |t| t&.product_sub_transaction&.first&.flow_type == "debit"}
    second_hand_transaction_in_today = second_hand_transaction_today.select{ |t| t&.product_sub_transaction&.first&.flow_type == "debit"}
    second_hand_transaction_out = second_hand_transaction.select{ |t| t&.product_sub_transaction&.first&.flow_type == "credit"}
    second_hand_transaction_out_today = second_hand_transaction_today.select{ |t| t&.product_sub_transaction&.first&.flow_type == "credit"}
    second_hand_transaction_each = Corner::Account::ProductSubTransaction.all
    second_hand_transaction_each_today = Corner::Account::ProductSubTransaction.where('$and' => [{:created_at => {:$gte => date}}, {:created_at => {:$lte => date+1}}])


    #for display
    second_hand_transaction_no_today = second_hand_transaction_today.count
    second_hand_transaction_no = second_hand_transaction.count
    second_hand_transaction_amount_today = second_hand_transaction_each_today.sum(:credit_amount)
    second_hand_transaction_amount = second_hand_transaction_each.sum(:credit_amount)
    second_hand_transaction_item_today = second_hand_transaction_each_today.sum(:quantity)
    second_hand_transaction_item = second_hand_transaction_each.sum(:quantity)

    second_hand_transaction_in_no_today = second_hand_transaction_in_today.count
    second_hand_transaction_in_no = second_hand_transaction_in.count
    second_hand_transaction_in_amount_today = second_hand_transaction_each_today.where(flow_type: "debit").sum(:credit_amount)
    second_hand_transaction_in_amount = second_hand_transaction_each.where(flow_type: "debit").sum(:credit_amount)
    second_hand_transaction_in_item_today = second_hand_transaction_each_today.where(flow_type: "debit").sum(:quantity)
    second_hand_transaction_in_item = second_hand_transaction_each.where(flow_type: "debit").sum(:quantity)

    second_hand_transaction_out_no_today = second_hand_transaction_out_today.count
    second_hand_transaction_out_no = second_hand_transaction_out.count
    second_hand_transaction_out_amount_today = second_hand_transaction_each_today.where(flow_type: "credit").sum(:credit_amount)
    second_hand_transaction_out_amount = second_hand_transaction_each.where(flow_type: "credit").sum(:credit_amount)
    second_hand_transaction_out_item_today = second_hand_transaction_each_today.where(flow_type: "credit").sum(:quantity)
    second_hand_transaction_out_item = second_hand_transaction_each.where(flow_type: "credit").sum(:quantity)

    poster = Glip::Poster.new("https://hooks.glip.com/webhook/72eb64e5-eecb-4139-9900-2e48791187aa")
    options = {
      icon: 'http://app.cuhappycorner.com/assets/logo/logo-60c5cc385eadf51330f450f6139d0fbcab520081ea93e385ed0e0179bf4b686a.png',
      activity: 'CU Happy Corner Statistics',
      title: 'Auto Statistics of ' + date.to_s
    }
    message = "*Note: Number inside bracket = Total* \n\n"
    message += "No. of User: "+ user_today.to_s + "  (*" + user.to_s +  "*) \n"
    message += "No. of Activated User:  "+ activated_user_today.to_s + "  (*" + activated_user.to_s +  "*) \n"
    message += "----------------------- \n"
    message += "[IN+OUT] \n"
    message += "No. of 2nd Hand Good Transaction:  "+ second_hand_transaction_no_today.to_s + "  (*" + second_hand_transaction_no.to_s +  "*) \n"
    message += "Amount of 2nd Hand Good Transaction (in terms of CU Happy Coins):  "+ second_hand_transaction_amount_today.to_s + "  (*" + second_hand_transaction_amount.to_s +  "*) \n"
    message += "Quantity of 2nd Hand Good Transaction (in terms of items): *"+ second_hand_transaction_item_today.to_s + "  (*" + second_hand_transaction_item.to_s +  "*) \n"
    poster.send_message(message, options)

    message = "[IN] \n"
    message += "No. of 2nd Hand Good Transaction:  "+ second_hand_transaction_in_no_today.to_s + "  (*" + second_hand_transaction_in_no.to_s +  "*) \n"
    message += "Amount of 2nd Hand Good Transaction (in terms of CU Happy Coins):  "+ second_hand_transaction_in_amount_today.to_s + "  (*" + second_hand_transaction_in_amount.to_s +  "*) \n"
    message += "Quantity of 2nd Hand Good Transaction (in terms of items):  "+ second_hand_transaction_in_item_today.to_s + "  (*" + second_hand_transaction_in_item.to_s +  "*) \n"
    message += "----------------------- \n"
    message += "[OUT] \n" 
    message += "No. of 2nd Hand Good Transaction: "+ second_hand_transaction_out_no_today.to_s + " (*" + second_hand_transaction_out_no.to_s +  "*) \n"
    message += "Amount of 2nd Hand Good Transaction (in terms of CU Happy Coins):  "+ second_hand_transaction_out_amount_today.to_s + "  (*" + second_hand_transaction_out_amount.to_s +  "*) \n"
    message += "Quantity of 2nd Hand Good Transaction (in terms of items):  "+ second_hand_transaction_out_item_today.to_s + "  (*" + second_hand_transaction_out_item.to_s +  "*) \n"
    poster.send_message(message, options)

    message = "[Detail] \n" 
    Corner::Pos::SecondHandGood.all.each do |pro|
      good_tran_date = second_hand_transaction_each_today.where(product: pro)
      no_in = good_tran_date.where(flow_type: "debit").sum(:quantity)
      message += "[IN]" + pro.name + ": " + no_in.to_s + "\n" if no_in > 0
      no_out = good_tran_date.where(flow_type: "credit").sum(:quantity)
      message += "[OUT]" + pro.name + ": " + no_out.to_s + "\n" if no_out > 0
    end

    poster.send_message(message, options)

  end
end