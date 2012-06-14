class SessionsController < ApplicationController
  def new
    redirect_to "/auth/#{params[:provider]}"
  end

  def create
    @user = current_user
    logger.debug "@user: #{@user.inspect}"
    @user ||= User.find_by_omniauth(auth)
    logger.debug "@user: #{@user.inspect}"
    @user ||= User.create_with_omniauth!(auth)
    logger.debug "@user: #{@user.inspect}"
    @user.update_omniauth_attributes!(auth)
    session[:user_id] = @user.id
    
    logger.debug "auth hash: #{auth.inspect}"
    
    redirect_to root_url, :notice => 'Signed in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

  protected

  def auth
    request.env["omniauth.auth"]
  end
end
