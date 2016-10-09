class Corner::Pos::SecondHandGoodController < ApplicationController
  include Corner::PosConcern
  before_action :authenticate_user!

  # GET
  def index
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  def new
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  # def create
  #   if !current_user.role.include? Role.find_by(name:"shopkeeper")
  #     flash[:alert] = t('error.notauthorized')
  #     redirect_to(request.referrer || root_path) and return
  #   end
  #   project = dsf
  #   item = Corner::Pos::SecondHandGood.create(project: project, sale_credit_price: sale_credit_price, purchase_credit_price: purchase_credit_price)
  #   item.name = params[:name_HK]
  #   item.name = params[:name_EN]

  # end

  def edit
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

  end

  def delete
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end

  end

  def new_category
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end

  end

  def create_category
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end

  end

  def edit_category
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end

  end

  def update_category
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end

  end

  def delete_category
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end

  end
end