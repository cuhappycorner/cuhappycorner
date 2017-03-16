class Corner::Users::NewGuestController < ApplicationController
  before_action :authenticate_user!
  # GET
  def index
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  # PUT
  def create
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end

    random_token = SecureRandom.hex(3)
    @cuid = "GU" + random_token.upcase
    while !User.find_by(cuid: @cuid).nil?
      random_token = SecureRandom.hex(3)
      @cuid = "GU" + random_token.upcase
    end
    @cu_link_id = @cuid
    @email = ""
    if params[:email].nil?
      @email = @cuid.downcase + "@guest.cuhappycorner.com"
    else
      @email = params[:email]
    end
    @password = SecureRandom.hex(4)
    cuid_type = :outside
    u_name = params[:u_name]
    display_name = params[:display_name]
    birthday = params[:birthday]
    gender = params[:gender].to_s.to_sym
    mobile = params[:mobile]
    major = params[:major] = User::Major.find_by code: params[:major].to_s
    @user = User.new(email: @email, password: @password, password_confirmation: @password, name_translations: u_name, cuid: @cuid, cu_link_id: @cu_link_id, cuid_type: cuid_type, display_name: display_name, birthday: birthday, gender: gender, mobile: mobile, major: major, activated: true, activated_at: Time.now)
    @user.save
  end
end
