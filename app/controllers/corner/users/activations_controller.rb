class Corner::Users::ActivationsController < ApplicationController
  include MemberConcern
  include Bank::AccountConcern

  before_action :authenticate_user!

  # GET
  def index
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  # GET
  def show
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @user = User.find_by(cuid: params[:cuid])
    if @user == nil
      flash[:notice] = t('corner.users.activations.show.error.notfound')
      redirect_to action:'index' and return
    end
  end

  # PUT
  def update
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @user = User.find_by(cuid: params[:cuid])
    if @user == nil
      flash[:notice] = t('corner.users.activations.show.error.notfound')
      redirect_to action:'index' and return
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
    if not @user.valid?
      flash[:error] = @user.errors.full_messages
      redirect_to(request.referrer || root_path) and return
    end

    member = activate_member(current_user, @user, params[:cu_link_id].upcase)
    if not member
      redirect_to(request.referrer || root_path) and return
    end

    status = bank_create_individual_account(current_user, @user)
    if not status
      redirect_to(request.referrer || root_path) and return
    end

    flash[:success] = t('corner.users.activations.show.success.activated')
    redirect_to action:'index' and return

  end
end