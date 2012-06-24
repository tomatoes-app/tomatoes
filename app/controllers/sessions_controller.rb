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
