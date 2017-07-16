class Corner::Users::RoleController < ApplicationController
  before_action :authenticate_user!

  # list
  def index
    unless (current_user.role.include? Role.find_by(name: 'board')) || (current_user.role.include? Role.find_by(name: 'admin'))
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @banker = Role.find_by(name: "banker")
    @board = Role.find_by(name: "board")
    @shopkeeper = Role.find_by(name: "shopkeeper")
    @shopkeeper_manager = Role.find_by(name: "shopkeeper_manager")
    @intranet = Role.find_by(name: "intranet")
  end

  def add
    unless (current_user.role.include? Role.find_by(name: 'board')) || (current_user.role.include? Role.find_by(name: 'admin'))
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @user = User.find_by(cuid: params[:cuid])
    @role = Role.find_by(name: params[:role])

    if @user.nil?
      flash[:success] = "User Not Found."
    elsif @user.role.include? @role
      flash[:success] = 'Role Already Assigned.'
    else
      @user.role << @role
      if params[:role] == "banker"
        HappyCorner.first.account.first.authorized_person << @user
      end
      @user.save
      @role.save
      flash[:success] = 'Role Assigned.'
    end
    redirect_to(action: 'index') and return
  end

  def remove
    unless (current_user.role.include? Role.find_by(name: 'board')) || (current_user.role.include? Role.find_by(name: 'admin'))
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @user = User.find_by(id: params[:user])
    @role = Role.find_by(name: params[:role])

    if @user.role.include? @role
      @user.role.delete(@role)
      if params[:role] == "banker"
        HappyCorner.first.account.first.authorized_person.delete(@user)
      end
      @user.save
      @role.save
      flash[:success] = 'Removed from Role.'
    else
      flash[:success] = 'Role Not Existed.'
    end
    redirect_to(action: 'index') and return
  end
end
