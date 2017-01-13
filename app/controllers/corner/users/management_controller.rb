class Corner::Users::ManagementController < ApplicationController
  # list
  def index
  end

  def search
    @users = if params[:query].present?
               Book.search(params[:query])
             else
               []
             end
  end

  def show
    @user = User.find_by(number: params[:number])
  end

  def edit
  end

  def update
  end

  def autocomplete
    if params[:query].present?
      render json: User.search(params[:query], load: false,
                                               limit: 10,
                                               misspellings: { below: 5 }).map do |user|
        { name: user.name, cuid: user.cuid, email: user.email }
      end
    end
  end
end
