class Corner::Users::ActivationsController < ApplicationController
  include Member
  include Bank

  before_action :authenticate_user!

  # GET
  def index

  end

  # GET
  def show
    @user = User.find_by(cuid: params[:cuid])
    if @user == nil
      flash[:notice] = t('corner.users.activations.show.error.notfound')
      redirect_to action:'index'
    end
  end

  # PUT
  def update
    @user = User.find_by(cuid: params[:cuid])
    if @user == nil
      flash[:notice] = t('corner.users.activations.show.error.notfound')
      redirect_to action:'index'
    end
    @user.name_translations[:en] = params[:eng_name]
    @user.name_translations[:zh_HK] = params[:chi_name]
    @user.display_name = params[:display_name]
    @user.cuid_type = params[:cuid_type].to_s.to_sym
    @user.email = params[:email]
    @user.mobile = params[:mobile]
    @user.major = User::Major.find_by code: params[:major].to_s
    @user.year_of_admission = params[:year_of_admission]
    @user.year_of_graduation = params[:year_of_graduation]
    @user.save

    activate_member(current_user, @user, params[:cu_link_id])
    bank_create_individual_account(current_user, @user)

    flash[:success] = t('corner.users.activations.show.success.activated')
    redirect_to action:'index'

  end
end