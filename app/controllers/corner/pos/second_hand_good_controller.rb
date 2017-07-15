class Corner::Pos::SecondHandGoodController < ApplicationController
  include Corner::PosConcern
  before_action :authenticate_user!

  # GET
  def index
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  def c_new
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  def c_create
    if !current_user.role.include? Role.find_by(name:"shopkeeper")
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @category = Corner::Pos::SecondHandGoodCategory.create(name: params[:name], order: params[:order])
    flash[:success] = 'New Category Created.'
    redirect_to(action: 'index') and return
  end

  def c_edit
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @category = Corner::Pos::SecondHandGoodCategory.find_by(id: params[:category])
  end

  def c_update
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @category = Corner::Pos::SecondHandGoodCategory.find_by(id: params[:category])
    @category.name = params[:name]
    @category.order = params[:order]
    @category.disabled = params[:disabled]
    @category.save
    flash[:success] = 'Category Updated.'
    redirect_to(action: 'index') and return
  end

  def c_show
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @category = Corner::Pos::SecondHandGoodCategory.find_by(id: params[:category])
  end


  def g_new
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  def g_create
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    project = Corner::Account::Project.find_by(number: "PJ-JO-317")
    category = Corner::Pos::SecondHandGoodCategory.find_by id: params[:category].to_s

    @good = Corner::Pos::SecondHandGood.create(project: project, category: category, name: params[:name], order: params[:order], purchase_credit_price: params[:purchase_credit_price], sale_credit_price: params[:sale_credit_price])

    flash[:success] = 'New Good Created.'
    redirect_to(action: 'c_show', category: @good.category.id) and return
  end

  def g_edit
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @good = Corner::Pos::SecondHandGood.find_by(id: params[:good])
  end

  def g_update
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @good = Corner::Pos::SecondHandGood.find_by(id: params[:good])
    @good.name = params[:name]
    @good.order = params[:order]
    @good.disabled = params[:disabled]
    @good.purchase_credit_price = params[:purchase_credit_price]
    @good.sale_credit_price = params[:sale_credit_price]
    @good.category = Corner::Pos::SecondHandGoodCategory.find_by id: params[:category].to_s
    @good.save
    flash[:success] = 'Good Updated.'
    redirect_to(action: 'c_show', category: @good.category.id) and return
  end
end
