require 'single_sign_on'

class Api::IntranetSsoController < ApplicationController
  before_action :authenticate_user! # ensures user must login

  def sso
    unless current_user.role.include? Role.find_by(name: 'intranet')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    secret = 'dzueCJ6lrAFlrLfoHWuD'
    sso = SingleSignOn.parse(request.query_string, secret)
    sso.email = current_user.email
    sso.name = current_user.name_translations[:en]
    sso.username = current_user.email
    sso.external_id = current_user.id
    sso.sso_secret = secret

    redirect_to sso.to_url('https://intranet.cuhappycorner.com/session/sso_login')
  end
end