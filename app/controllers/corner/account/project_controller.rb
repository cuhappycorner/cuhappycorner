class Corner::Account::ProjectController < ApplicationController
  include Corner::AccountConcern

  before_action :authenticate_user!

  def index
    unless current_user.role.include? Role.find_by(name: 'board')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @projects = Corner::Account::Project.all
  end

  def create
    unless current_user.role.include? Role.find_by(name: 'board')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    if ((params[:name] == "Individual Loan") || (params[:name] == "Second Hand Goods") || (params[:name] == "Salary"))
      flash[:success] = 'Rejected! Name includes reserved word.'
      redirect_to(action: 'index') and return
    end

    Corner::Account::Project.create(name: params[:name])
    flash[:success] = 'Project created.'
    redirect_to(action: 'index') and return
  end

  def add_budget
    unless current_user.role.include? Role.find_by(name: 'board')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end

    @project = Corner::Account::Project.find_by(id: params[:id])

    @budget = Corner::Account::CreditBudgetRecord.create(project: @project, amount: params[:amount])

    flash[:success] = 'Budget added.'
    redirect_to(action: 'index') and return
  end

  def show
    unless current_user.role.include? Role.find_by(name: 'board')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @project = Corner::Account::Project.find_by(id: params[:id])
    @shopkeepers = Role.find_by(name: 'shopkeeper').user.order_by(name: :asc)
  end

  def add_person
    unless current_user.role.include? Role.find_by(name: 'board')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @project = Corner::Account::Project.find_by(id: params[:id])
    @user = User.find_by(id: params[:user])

    if @user.nil?
      flash[:success] = "User Not Found."
    elsif @project.authorized_person.include? @user
      flash[:success] = 'Role Already Assigned.'
    else
      @project.authorized_person << @user
      @project.save
      @user.save
      flash[:success] = 'Role Assigned.'
    end
    redirect_to(action: 'show', id: @project.id) and return
  end

  def remove_person
    unless current_user.role.include? Role.find_by(name: 'board')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end

    @project = Corner::Account::Project.find_by(id: params[:id])
    @user = User.find_by(id: params[:user])

    if @user.nil?
      flash[:success] = "User Not Found."
    elsif @project.authorized_person.include? @user
      @project.authorized_person.delete(@user)
      @user.save
      @project.save
      flash[:success] = 'Removed from Role.'
    else
      flash[:success] = 'Role Not Existed.'
    end
    redirect_to(action: 'show', id: @project.id) and return
  end
end
