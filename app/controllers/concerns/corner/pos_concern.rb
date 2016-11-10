module Corner::PosConcern
  extend ActiveSupport::Concern

  def corner_pos_create_transaction(operator, entity, item_array)
    # TODO: Catch error if not enough credit in Corner Account/Corner Project Budget

    credit_amount_sum = 0 # Positive: Corner collect; Negative: Corner Pay
    cash_amount_sum = 0
    item_array.each do |item|
      if item['flow_type'] == 'debit'
        # credit_amount_sum -= item['quantity'] * item['product'].purchase_credit_price
        # cash_amount_sum -= item['quantity'] * item['product'].purchase_cash_price
        credit_amount_sum -= item['quantity'] * item['purchase_credit_price']
        cash_amount_sum -= item['quantity'] * item['purchase_cash_price']
      else
        # credit_amount_sum += item['quantity'] * item['product'].sale_credit_price
        # cash_amount_sum += item['quantity'] * item['product'].sale_cash_price
        credit_amount_sum += item['quantity'] * item['sale_credit_price']
        cash_amount_sum += item['quantity'] * item['sale_cash_price']
      end
    end

    # entity = User.find_by(cuid: entity.cuid)
    # if credit_amount_sum > 0
    #   if !entity.is_a? User
    #     flash[:error] = "Not a user"
    #     return false
    #   else
    #     if entity.account = nil
    #       flash[:error] = "No Account"
    #       return false
    #     else
    #       # if entity.account.balance < credit_amount_sum
    #       #   flash[:error] = "Not enough credit"
    #       #   return false
    #       # end
    #       flash[:error] = entity.account
    #       return false
    #     end
    #   end
    # end

    transaction = Corner::Account::PosTransaction.create(operator: operator)

    credit_transaction = nil
    if credit_amount_sum > 0
      credit_transaction = Corner::Account::PosCreditTransaction.create(operator: operator, creditor: HappyCorner.first.account.first, debitor: entity.account, amount: credit_amount_sum, transaction: transaction, detail: 'POS Transaction @CU Happy Corner')
    elsif credit_amount_sum < 0
      credit_transaction = Corner::Account::PosCreditTransaction.create(operator: operator, creditor: entity.account, debitor: HappyCorner.first.account.first, amount: -1 * credit_amount_sum, transaction: transaction, detail: 'POS Transaction @CU Happy Corner')
    end

    cash_transaction = nil
    if cash_amount_sum > 0
      cash_transaction = Corner::Account::PosCashTransaction.create(transaction: transaction, flow_type: 'credit', amount: cash_amount_sum)
    else
      cash_transaction = Corner::Account::PosCashTransaction.create(transaction: transaction, flow_type: 'debit', amount: cash_amount_sum)
    end
    item_array.each do |item|
      if item['flow_type'] == 'debit'
        credit_amount_sum -= item['quantity'] * item['product'].purchase_credit_price
        cash_amount_sum -= item['quantity'] * item['product'].purchase_cash_price

        product_sub_transaction = Corner::Account::ProductSubTransaction.create(flow_type: 'debit', product: item['product'], quantity: item['quantity'], unit_credit_price: item['product'].purchase_credit_price, unit_cash_price: item['product'].purchase_cash_price, credit_amount: item['quantity'] * item['product'].purchase_credit_price, cash_amount: item['quantity'] * item['product'].purchase_cash_price, project: item['product'].project, transaction: transaction)
      else
        product_sub_transaction = Corner::Account::ProductSubTransaction.create(flow_type: 'credit', product: item['product'], quantity: item['quantity'], unit_credit_price: item['product'].sale_credit_price, unit_cash_price: item['product'].sale_cash_price, credit_amount: item['quantity'] * item['product'].sale_credit_price, cash_amount: item['quantity'] * item['product'].sale_cash_price, project: item['product'].project, transaction: transaction)
      end
      return transaction
    end
  end
end
