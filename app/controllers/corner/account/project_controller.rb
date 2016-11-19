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
end
