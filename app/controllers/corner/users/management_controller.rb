class Corner::Users::ManagementController < ApplicationController
  before_action :authenticate_user!

  # list
  def index
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  def edit
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @user = User.find_by(id: params[:id])
  end

  def update
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @user = User.find_by(id: params[:id])

    if params[:page] == "general"
      @user.name_translations[:en] = params[:user_name_translations_en]
      @user.name_translations[:zh_HK] = params[:user_name_translations_zh_HK]
      @user.display_name = params[:user_display_name]
      @user.gender = params[:user_gender]
      @user.birthday = params[:user_birthday]
      @user.mobile = params[:user_mobile]
      @user.email = params[:user_email]
    elsif params[:page] == "cuer"
      @user.cuid = params[:user_cuid]
      @user.cuid_type = params[:user_cuid_type]
      @user.cu_resident = params[:user_cu_resident]
      @user.major = User::Major.find_by code: params[:user_major].to_s
      @user.year_of_graduation = params[:user_year_of_graduation]
      @user.year_of_admission = params[:user_year_of_admission]
    end
    @user.save
    flash[:success] = 'User Information Updated.'
    redirect_to(action: 'edit', id: @user.id) and return


  end
end
