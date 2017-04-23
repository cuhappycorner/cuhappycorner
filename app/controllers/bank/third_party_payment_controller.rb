class Bank::ThirdPartyPaymentController < ApplicationController
  before_action :authenticate_user!
  layout "third_party_payment"

  # GET
  def show
    @payment = Bank::ThirdPartyPayment.find_by(id: params[:id])
    if @payment.debitor.is_a? Bank::IndividualAccount
      unless @payment.debitor.owner.eql? current_user
        flash[:alert] = t('error.notauthorized')
        redirect_to(request.referrer || root_path) and return
      end
    elsif @payment.debitor.is_a? Bank::OrganizationalAccount
      unless @payment.debitor.authorized_person.where(id: current_user.id).exists?
        flash[:alert] = t('error.notauthorized')
        redirect_to(request.referrer || root_path) and return
      end
    end
  end

  # POST
  def pay
    @payment = Bank::ThirdPartyPayment.find_by(id: params[:id])
    if @payment.debitor.is_a? Bank::IndividualAccount
      unless @payment.debitor.owner.eql? current_user
        flash[:alert] = t('error.notauthorized')
        redirect_to(request.referrer || root_path) and return
      end
    elsif @payment.debitor.is_a? Bank::OrganizationalAccount
      unless @payment.debitor.authorized_person.where(id: current_user.id).exists?
        flash[:alert] = t('error.notauthorized')
        redirect_to(request.referrer || root_path) and return
      end
    end

    transaction = Bank::ThirdPartyTransaction.create(payment: @payment, amount: @payment.amount, operator: current_user, debitor: @payment.debitor, creditor: @payment.creditor, detail: @payment.detail)

    if transaction
      @payment.paid = true
      @payment.save
    else
      flash[:alert] = 'Error Occurred'
      redirect_to(request.referrer || root_path) and return
    end
  end
end