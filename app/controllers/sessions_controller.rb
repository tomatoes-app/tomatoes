class SessionsController < ApplicationController
  def new
    redirect_to "/auth/#{params[:provider]}"
  end

  def create
    @user = current_user
    @user ||= User.find_by_omniauth(auth)
    @user ||= User.create_with_omniauth!(auth)
    @user.update_omniauth_attributes!(auth)
    session[:user_id] = @user.id

    redirect_to root_url, notice: I18n.t('session.created')
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: I18n.t('session.deleted')
  end

  def failure
    redirect_to root_url, alert: I18n.t('session.failure', error_message: error_message)
  end

  protected

  def auth
    request.env['omniauth.auth']
  end

  def error_message
    params[:message].try(:humanize) || I18n.t('session.unexpected_error')
  end
end
