class UserController < ApplicationController
  def check_email
    if user_signed_in?
      if current_user.email == params[:user][:email]
        respond_to do |format|
          format.json { render json: true }
        end
        return
      end
    end
    @user = User.find_by(email: params[:user][:email])

    respond_to do |format|
      format.json { render json: !@user }
    end
  end

  def check_email2
    @user = User.find_by(email: params[:user])

    respond_to do |format|
      format.json { render json: !@user }
    end
  end

  def check_cuid
    @user = User.find_by(cuid: params[:user][:cuid])

    respond_to do |format|
      format.json { render json: !@user }
    end
  end

  def check_cu_link_id
    @user = User.find_by(cu_link_id: params[:cu_link_id].upcase)

    respond_to do |format|
      format.json { render json: !@user }
    end
  end

  def check_activated
    @user = User.find_by(cuid: params[:cuid])
    @activated = false
    @activated = @user.activated if @user.respond_to? :activated

    respond_to do |format|
      format.json { render json: @activated }
    end
  end
end
