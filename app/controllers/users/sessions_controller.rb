class Users::SessionsController < Devise::SessionsController
  layout 'login', only: [:new]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    begin
      client = DiscourseApi::Client.new("https://intranet.cuhappycorner.com")
      client.api_key = "1729b13700d45e58d2e3d81c1bee5431a5167244e75389c07bb613fae54777ee"
      client.api_username = "ckho"
      user = client.by_external_id(current_user.id)
      client.log_out(user["id"]) if user
    rescue
      # nothing
    ensure
      super
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
