class UserController < ApplicationController
  def check_email
    @user = User.find_by(email: params[:user][:email])

    respond_to do |format|
     format.json { render :json => !@user }
    end
  end

  def check_cuid
    @user = User.find_by(cuid: params[:user][:cuid])

    respond_to do |format|
     format.json { render :json => !@user }
    end
  end

  def check_cu_link_id
    @user = User.find_by(cu_link_id: params[:cu_link_id].upcase)

    respond_to do |format|
     format.json { render :json => !@user }
    end
  end

  def check_activated
    @user = User.find_by(cuid: params[:cuid])
    @activated = false
    if @user.respond_to? :activated
      @activated = @user.activated
    end

    respond_to do |format|
      format.json { render :json => @activated }
    end
  end
end