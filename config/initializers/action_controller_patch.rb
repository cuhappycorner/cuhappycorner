module ActionController
  Base.class_eval do

    def current_user_helper
      @current_user_helper ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user_helper

  end
end