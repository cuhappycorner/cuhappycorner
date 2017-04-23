module Api::V1
  class AccountController < ApiController
    before_action :doorkeeper_authorize!
    respond_to     :json

    def account_number
      respond_with current_resource_owner.account.number
    end

    def account_balance
      respond_with current_resource_owner.account.balance
    end

    def account_number_from_cuid
      respond_with User.find_by(cuid: params[:cuid]).account.number
    end

    def create_payment
      debitor = Bank::Account.find_by(number: params[:debitor])
      creditor = Bank::Account.find_by(number: params[:creditor])
      amount = params[:amount]
      detail = params[:detail]
      callback_url = params[:callback_url]
      if (!creditor || amount <= 0 || detail.blank? || callback_url.blank?)
        render nothing: true, status: 400 and return
      end
      if debitor.is_a? Bank::IndividualAccount
        unless debitor.owner.eql? current_resource_owner
          render nothing: true, status: 403 and return
        end
      elsif debitor.is_a? Bank::OrganizationalAccount
        unless debitor.authorized_person.where(id: current_resource_owner.id).exists?
          render nothing: true, status: 403 and return
        end
      end
      payment = Bank::ThirdPartyPayment.create(application: doorkeeper_token.application,
                                               debitor: debitor, creditor: creditor,
                                               amount: amount, detail: detail,
                                               callback_url: callback_url)
      respond_with payment.id
    end

    def check_payment_paid
      payment = Bank::ThirdPartyPayment.find_by(number: params[:id])
      unless payment
        render nothing: true, status: 403 and return
      end
      response_with payment.paid
    end
  end
end