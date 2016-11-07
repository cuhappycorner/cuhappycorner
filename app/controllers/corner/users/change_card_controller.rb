class Corner::Users::ChangeCardController < ApplicationController

  before_action :authenticate_user!

  def index
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

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
    @user.cu_link_id = params[:cu_link_id].upcase
    @user.save

    flash[:success] = "CU Link ID Successfully Changed!"
    redirect_to action:'index' and return
  end

  def get_info
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end

    name = nil
    entity = User.find_by(cuid: params[:cuid])

    if entity != nil
      name = entity.name
    end

    @status = {:name => name}
    render json: @status
  end
end