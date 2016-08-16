class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :controller => 'main', :action => 'index' 
  end

  protected

  def configure_permitted_parameters
  	devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :display_name, :chi_name, :password, :password_confirmation, :gender, :mobile, :name, :date_of_birth, :cu_identity, :cu_identity_no, :major, :year_of_admission, :year_of_graduation, :cu_resident) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password, :gender, :mobile, :name, :date_of_birth, :cu_identity, :cu_identity_no, :major, :year_of_admission, :year_of_graduation, :cu_resident, :display_name, :chi_name) }
  end

  def current_ability
    # I am sure there is a slicker way to capture the controller namespace
    controller_name_segments = params[:controller].split('/')
    controller_name_segments.pop
    controller_namespace = controller_name_segments.join('/').camelize
    Ability.new(current_user, controller_namespace)
  end

end
