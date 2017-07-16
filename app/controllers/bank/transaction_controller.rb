class Bank::TransactionController < ApplicationController
  include Bank::LoanConcern

  before_action :authenticate_user!

  # GET
  def index
    unless (current_user.role.include? Role.find_by(name: 'shopkeeper'))
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  # GET
  def show_pos
    @transaction = Bank::Transaction.find_by(id: params[:id])

    unless (current_user.role.include? Role.find_by(name: 'shopkeeper'))
      if @transaction.debitor.is_a? Bank::IndividualAccount
        unless @transaction.debitor.owner.eql? current_user

          if @transaction.creditor.is_a? Bank::IndividualAccount
            unless @transaction.creditor.owner.eql? current_user
              flash[:alert] = t('error.notauthorized')
              redirect_to(request.referrer || root_path) and return
            end
          elsif @transaction.creditor.is_a? Bank::OrganizationalAccount
            unless @transaction.creditor.authorized_person.where(id: current_user.id).exists?
              flash[:alert] = t('error.notauthorized')
              redirect_to(request.referrer || root_path) and return
            end
          end

        end
      elsif @transaction.debitor.is_a? Bank::OrganizationalAccount
        unless @transaction.debitor.authorized_person.where(id: current_user.id).exists?

          if @transaction.creditor.is_a? Bank::IndividualAccount
            unless @transaction.creditor.owner.eql? current_user
              flash[:alert] = t('error.notauthorized')
              redirect_to(request.referrer || root_path) and return
            end
          elsif @transaction.creditor.is_a? Bank::OrganizationalAccount
            unless @transaction.creditor.authorized_person.where(id: current_user.id).exists?
              flash[:alert] = t('error.notauthorized')
              redirect_to(request.referrer || root_path) and return
            end
          end

        end
      end
    end

    unless @transaction.is_a? Corner::Account::PosCreditTransaction
      flash[:alert] = "NOT A POS TRANSACTION"
      redirect_to(request.referrer || root_path) and return
    end

    @sub_transactions = @transaction.transaction.product_sub_transaction.all
  end

  def update
    unless (current_user.role.include? Role.find_by(name: 'shopkeeper'))
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @transaction = Bank::Transaction.find_by(id: params[:id])

    @transaction.detail = params[:detail]
    @transaction.save
    flash[:success] = 'Transaction Details Updated.'
    redirect_to(root_path) and return
  end
end